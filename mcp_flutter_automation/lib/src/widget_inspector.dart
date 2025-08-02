import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:logging/logging.dart';
import 'flutter_controller.dart';

/// Widget inspector that combines screenshot capture with widget tree analysis
/// to provide interactive debugging capabilities similar to Flutter Inspector
class WidgetInspector {
  final _logger = Logger('WidgetInspector');
  final FlutterController _controller;

  WidgetInspector(this._controller);

  /// Captures a screenshot with widget boundary overlays and inspection data
  Future<WidgetInspectionResult> inspectWithScreenshot(
    String appId, {
    bool includeWidgetBounds = true,
    bool includeWidgetTree = true,
    String? filename,
  }) async {
    _logger.info('Starting widget inspection for app: $appId');

    try {
      // 1. Capture base screenshot
      final screenshotBase64 = await _controller.captureScreenshot(appId);
      if (screenshotBase64 == null) {
        throw Exception('Failed to capture screenshot');
      }

      // 2. Get widget tree
      Map<String, dynamic> widgetTree = {};
      if (includeWidgetTree) {
        widgetTree = await _controller.getWidgetTree(appId);
      }

      // 3. Extract widget render information with bounds
      final widgets = await _extractWidgetRenderInfo(appId);

      // 4. Create inspection result
      final result = WidgetInspectionResult(
        appId: appId,
        screenshotBase64: screenshotBase64,
        widgetTree: widgetTree,
        widgets: widgets,
        timestamp: DateTime.now(),
      );

      // 5. Save inspection data to file if filename provided
      if (filename != null) {
        await _saveInspectionData(appId, result, filename);
      }

      _logger.info('Widget inspection completed successfully');
      return result;
    } catch (e) {
      _logger.severe('Widget inspection failed: $e');
      rethrow;
    }
  }

  /// Extracts detailed widget render information including bounds and properties
  Future<List<WidgetInfo>> _extractWidgetRenderInfo(String appId) async {
    _logger.info('Starting widget render info extraction for app: $appId');

    // Get app info to check connection status
    final appInfo = _controller.getAppInfo(appId);
    if (!appInfo['hasVmService']) {
      _logger.warning('VM Service not connected for app $appId');
      throw Exception('VM Service not connected for app $appId');
    }

    _logger.info('VM service confirmed available, proceeding with extraction');

    try {
      // Use the existing getWidgetTree method to get widget data
      _logger.info('Fetching widget tree data...');
      final widgetTreeData = await _controller.getWidgetTree(appId);

      _logger.info('Widget tree data received, processing for bounds...');
      _logger.fine('Widget tree structure: ${widgetTreeData.toString()}');

      // Extract widget information from the widget tree data
      final widgets = <WidgetInfo>[];
      await _processWidgetTreeDataWithBounds(appId, widgetTreeData, widgets);

      _logger.info(
          'Widget extraction completed. Found ${widgets.length} widgets with render info');

      // Log details about extracted widgets
      for (final widget in widgets) {
        if (widget.renderBox != null) {
          _logger.fine(
              'Widget ${widget.id} (${widget.type}): bounds=${widget.renderBox!.x},${widget.renderBox!.y},${widget.renderBox!.width},${widget.renderBox!.height}');
        } else {
          _logger.fine('Widget ${widget.id} (${widget.type}): no render box');
        }
      }

      return widgets;
    } catch (e) {
      _logger.warning('Failed to extract widget render info: $e');
      return [];
    }
  }

  /// Processes widget tree data with bounds extraction using Flutter Inspector
  Future<void> _processWidgetTreeDataWithBounds(
    String appId,
    Map<String, dynamic> widgetTreeData,
    List<WidgetInfo> widgets,
  ) async {
    try {
      // Process widget tree and get render object bounds via Flutter Inspector
      if (widgetTreeData.containsKey('children')) {
        final children = widgetTreeData['children'] as List?;
        if (children != null) {
          for (final child in children) {
            if (child is Map<String, dynamic>) {
              await _processWidgetTreeNodeWithBounds(appId, child, widgets);
            }
          }
        }
      } else {
        // Process single widget node
        await _processWidgetTreeNodeWithBounds(appId, widgetTreeData, widgets);
      }
    } catch (e) {
      _logger.fine('Error processing widget tree data with bounds: $e');
    }
  }

  /// Recursively processes individual widget tree nodes with bounds extraction
  Future<void> _processWidgetTreeNodeWithBounds(
    String appId,
    Map<String, dynamic> node,
    List<WidgetInfo> widgets,
  ) async {
    try {
      // Extract basic widget info from the node
      final widgetId = node['objectId'] as String?;
      final widgetType =
          node['description'] as String? ?? node['name'] as String?;

      _logger.fine('Processing widget node: id=$widgetId, type=$widgetType');

      if (widgetId != null && widgetType != null) {
        _logger.info('Processing widget: $widgetType (ID: $widgetId)');

        // Get render object bounds using Flutter Inspector API
        final renderBox = await _getRenderObjectBounds(appId, widgetId);

        // Create widget info with bounds data
        final widgetInfo = WidgetInfo(
          id: widgetId,
          type: widgetType,
          properties: _extractPropertiesFromNode(node),
          renderBox: renderBox,
        );

        widgets.add(widgetInfo);
        _logger.info(
            'Added widget to list: $widgetType (render box: ${renderBox != null ? 'found' : 'null'})');
      } else {
        _logger.fine('Skipping node: missing widgetId or widgetType');
      }

      // Process children recursively
      final children = node['children'] as List?;
      if (children != null) {
        _logger.fine('Processing ${children.length} child nodes');
        for (final child in children) {
          if (child is Map<String, dynamic>) {
            await _processWidgetTreeNodeWithBounds(appId, child, widgets);
          }
        }
      }
    } catch (e) {
      _logger.warning('Error processing widget tree node with bounds: $e');
    }
  }

  /// Extracts properties from a widget tree node
  Map<String, dynamic> _extractPropertiesFromNode(Map<String, dynamic> node) {
    final properties = <String, dynamic>{};

    // Extract common properties
    if (node.containsKey('properties')) {
      final nodeProps = node['properties'];
      if (nodeProps is Map<String, dynamic>) {
        properties.addAll(nodeProps);
      }
    }

    // Add other relevant fields
    for (final key in ['description', 'name', 'type', 'hasChildren']) {
      if (node.containsKey(key)) {
        properties[key] = node[key];
      }
    }

    return properties;
  }

  /// Gets render object bounds using Flutter Inspector API
  Future<RenderBoxInfo?> _getRenderObjectBounds(
      String appId, String widgetId) async {
    try {
      _logger.info('Getting render object bounds for widget: $widgetId');

      // Get app instance to access VM service
      final app = _controller.getAppInstance(appId);
      if (app?.vmService == null || app?.isolateId == null) {
        _logger
            .warning('No VM service or isolate ID available for app: $appId');
        return null;
      }

      _logger.info('VM service available, trying multiple inspector methods');

      // Try multiple Flutter Inspector extension methods for getting widget bounds
      final extensionMethods = [
        'ext.flutter.inspector.getDetailsSubtree',
        'ext.flutter.inspector.getProperties',
        'ext.flutter.inspector.getRenderObject',
      ];

      for (final methodName in extensionMethods) {
        try {
          _logger.info('Trying extension method: $methodName');

          final response = await app!.vmService!.callServiceExtension(
            methodName,
            isolateId: app.isolateId,
            args: {
              'objectId': widgetId,
              'objectGroup': 'inspector',
            },
          );

          _logger.info('Extension $methodName response received');
          final details = response.json;

          if (details == null) {
            _logger.warning(
                'No details returned from $methodName for widget: $widgetId');
            continue;
          }

          _logger.fine('$methodName response: ${details.toString()}');

          // Try to extract bounds from different response structures
          final renderBox = _extractRenderBoxFromResponse(details, widgetId);
          if (renderBox != null) {
            _logger.info('Successfully extracted bounds using $methodName');
            return renderBox;
          }
        } catch (e) {
          _logger.warning('Extension method $methodName failed: $e');
          continue;
        }
      }

      _logger.warning('All extension methods failed for widget: $widgetId');
    } catch (e) {
      _logger.warning('Failed to get render object bounds for $widgetId: $e');
    }

    return null;
  }

  /// Extracts render box information from Flutter Inspector response
  RenderBoxInfo? _extractRenderBoxFromResponse(
      Map<String, dynamic> details, String widgetId) {
    try {
      // Method 1: Look for renderObject in details
      final renderObject = details['renderObject'] as Map<String, dynamic>?;
      if (renderObject != null) {
        final size = renderObject['size'] as Map<String, dynamic>?;
        if (size != null) {
          final width = (size['width'] as num?)?.toDouble() ?? 0.0;
          final height = (size['height'] as num?)?.toDouble() ?? 0.0;

          if (width > 0 || height > 0) {
            _logger.info(
                'Widget $widgetId size from renderObject: ${width}x$height');
            return RenderBoxInfo(x: 0.0, y: 0.0, width: width, height: height);
          }
        }
      }

      // Method 2: Look for size directly in details
      final directSize = details['size'] as Map<String, dynamic>?;
      if (directSize != null) {
        final width = (directSize['width'] as num?)?.toDouble() ?? 0.0;
        final height = (directSize['height'] as num?)?.toDouble() ?? 0.0;

        if (width > 0 || height > 0) {
          _logger
              .info('Widget $widgetId size from direct size: ${width}x$height');
          return RenderBoxInfo(x: 0.0, y: 0.0, width: width, height: height);
        }
      }

      // Method 3: Look in properties array for size/bounds information
      final properties = details['properties'] as List?;
      if (properties != null) {
        for (final prop in properties) {
          if (prop is Map<String, dynamic>) {
            final name = prop['name'] as String?;
            final value = prop['value'];

            if (name != null &&
                (name.contains('size') || name.contains('Size'))) {
              _logger.info('Found size property: $name = $value');

              // Try to parse size values from string
              if (value is String) {
                final sizeMatch =
                    RegExp(r'Size\(([^,]+),\s*([^)]+)\)').firstMatch(value);
                if (sizeMatch != null) {
                  final width = double.tryParse(sizeMatch.group(1)!) ?? 0.0;
                  final height = double.tryParse(sizeMatch.group(2)!) ?? 0.0;

                  if (width > 0 || height > 0) {
                    _logger
                        .info('Widget $widgetId parsed size: ${width}x$height');
                    return RenderBoxInfo(
                        x: 0.0, y: 0.0, width: width, height: height);
                  }
                }
              }
            }
          }
        }
      }

      _logger.fine('No size information found in response structure');
      return null;
    } catch (e) {
      _logger.warning('Error extracting render box from response: $e');
      return null;
    }
  }

  /// Saves inspection data to files for analysis
  Future<void> _saveInspectionData(
    String appId,
    WidgetInspectionResult result,
    String filename,
  ) async {
    try {
      // Get project path from app info
      final appInfo = _controller.getAppInfo(appId);
      final projectPath = appInfo['projectPath'] as String;

      // Save screenshot
      final screenshotBytes = base64Decode(result.screenshotBase64);
      final screenshotFile = File('$projectPath/${filename}_screenshot.png');
      await screenshotFile.writeAsBytes(screenshotBytes);

      // Save inspection data as JSON
      final inspectionData = {
        'appId': result.appId,
        'timestamp': result.timestamp.toIso8601String(),
        'widgetTree': result.widgetTree,
        'widgets': result.widgets.map((w) => w.toJson()).toList(),
        'screenshotFile': '${filename}_screenshot.png',
      };

      final dataFile = File('$projectPath/${filename}_inspection.json');
      await dataFile.writeAsString(json.encode(inspectionData));

      _logger.info('Inspection data saved to: ${dataFile.path}');
    } catch (e) {
      _logger.warning('Failed to save inspection data: $e');
    }
  }

  /// Finds widgets at a specific screen coordinate
  Future<List<WidgetInfo>> getWidgetsAtPosition(
    String appId,
    double x,
    double y,
  ) async {
    final result =
        await inspectWithScreenshot(appId, includeWidgetBounds: true);

    final matchingWidgets = <WidgetInfo>[];
    for (final widget in result.widgets) {
      if (widget.renderBox != null && widget.renderBox!.containsPoint(x, y)) {
        matchingWidgets.add(widget);
      }
    }

    // Sort by area (smallest first - most specific widget)
    matchingWidgets.sort((a, b) {
      final aArea = a.renderBox!.area;
      final bArea = b.renderBox!.area;
      return aArea.compareTo(bArea);
    });

    return matchingWidgets;
  }

  /// Creates an annotated screenshot with widget boundaries overlay
  Future<Uint8List> createAnnotatedScreenshot(
    String appId, {
    bool showWidgetBounds = true,
    bool showWidgetLabels = false,
  }) async {
    final result = await inspectWithScreenshot(appId);

    // For now, return the original screenshot
    // In a full implementation, you would overlay widget boundaries using image processing
    return base64Decode(result.screenshotBase64);
  }
}

/// Result of widget inspection containing screenshot and widget data
class WidgetInspectionResult {
  final String appId;
  final String screenshotBase64;
  final Map<String, dynamic> widgetTree;
  final List<WidgetInfo> widgets;
  final DateTime timestamp;

  WidgetInspectionResult({
    required this.appId,
    required this.screenshotBase64,
    required this.widgetTree,
    required this.widgets,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'appId': appId,
        'screenshotBase64': screenshotBase64,
        'widgetTree': widgetTree,
        'widgets': widgets.map((w) => w.toJson()).toList(),
        'timestamp': timestamp.toIso8601String(),
      };
}

/// Information about a specific widget including render properties
class WidgetInfo {
  final String id;
  final String type;
  final Map<String, dynamic> properties;
  final RenderBoxInfo? renderBox;

  WidgetInfo({
    required this.id,
    required this.type,
    required this.properties,
    this.renderBox,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'properties': properties,
        'renderBox': renderBox?.toJson(),
      };
}

/// Render box information including position and size
class RenderBoxInfo {
  final double x;
  final double y;
  final double width;
  final double height;

  RenderBoxInfo({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  bool containsPoint(double pointX, double pointY) {
    return pointX >= x &&
        pointX <= x + width &&
        pointY >= y &&
        pointY <= y + height;
  }

  double get area => width * height;

  Map<String, dynamic> toJson() => {
        'x': x,
        'y': y,
        'width': width,
        'height': height,
      };
}
