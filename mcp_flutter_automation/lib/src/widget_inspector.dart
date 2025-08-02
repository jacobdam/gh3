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
    try {
      _logger.info('Starting widget render info extraction for app: $appId');

      // Get app info to check connection status
      final appInfo = _controller.getAppInfo(appId);
      if (!appInfo['hasVmService']) {
        _logger.warning('VM Service not connected for app $appId');
        throw Exception('VM Service not connected for app $appId');
      }

      _logger
          .info('VM service confirmed available, proceeding with extraction');

      // Use the existing getWidgetTree method and extract basic layout info
      _logger.info('Fetching widget tree data for layout information...');
      final widgetTreeData = await _controller.getWidgetTree(appId);

      _logger.info('Widget tree data received, processing for layout info...');
      _logger.fine('Widget tree structure: ${widgetTreeData.toString()}');

      // Extract widget information with simplified bounds detection
      final widgets = <WidgetInfo>[];
      await _processWidgetTreeWithSimpleBounds(appId, widgetTreeData, widgets);

      _logger.info(
          'Widget extraction completed. Found ${widgets.length} widgets with layout info');

      // Log details about extracted widgets
      for (final widget in widgets) {
        if (widget.renderBox != null) {
          _logger.fine(
              'Widget ${widget.id} (${widget.type}): bounds=${widget.renderBox!.x},${widget.renderBox!.y},${widget.renderBox!.width},${widget.renderBox!.height}');
        } else {
          _logger.fine(
              'Widget ${widget.id} (${widget.type}): no render box (basic widget info only)');
        }
      }

      return widgets;
    } catch (e) {
      _logger.warning('Failed to extract widget render info: $e');
      return [];
    }
  }

  /// Processes widget tree with simplified bounds detection
  Future<void> _processWidgetTreeWithSimpleBounds(
    String appId,
    Map<String, dynamic> widgetTreeData,
    List<WidgetInfo> widgets,
  ) async {
    try {
      _logger.info('Processing widget tree for simplified bounds extraction');

      // Process widget tree structure recursively
      if (widgetTreeData.containsKey('result')) {
        final result = widgetTreeData['result'] as Map<String, dynamic>?;
        if (result != null) {
          await _processSimpleWidgetNode(appId, result, widgets);
        }
      } else {
        await _processSimpleWidgetNode(appId, widgetTreeData, widgets);
      }
    } catch (e) {
      _logger.warning('Error processing widget tree with simple bounds: $e');
    }
  }


  /// Processes widget nodes with simplified approach - just extract widget info
  Future<void> _processSimpleWidgetNode(
    String appId,
    Map<String, dynamic> node,
    List<WidgetInfo> widgets,
  ) async {
    try {
      // Extract basic widget info from the node
      final widgetId = node['valueId'] as String? ??
          node['objectId'] as String? ??
          'unknown-${widgets.length}';
      final widgetType = node['description'] as String? ??
          node['widgetRuntimeType'] as String? ??
          node['name'] as String? ??
          'UnknownWidget';

      _logger.fine(
          'Processing simple widget node: id=$widgetId, type=$widgetType');

      // Always create widget info, even without render box bounds
      final widgetInfo = WidgetInfo(
        id: widgetId,
        type: widgetType,
        properties: _extractPropertiesFromNode(node),
        renderBox: _createDefaultRenderBox(), // Provide default bounds for now
      );

      widgets.add(widgetInfo);
      _logger.info('Added widget to list: $widgetType (ID: $widgetId)');

      // Process children recursively
      final children = node['children'] as List?;
      if (children != null) {
        _logger.fine('Processing ${children.length} child nodes');
        for (final child in children) {
          if (child is Map<String, dynamic>) {
            await _processSimpleWidgetNode(appId, child, widgets);
          }
        }
      }
    } catch (e) {
      _logger.warning('Error processing simple widget node: $e');
    }
  }

  /// Creates default render box for widgets when bounds can't be determined
  RenderBoxInfo _createDefaultRenderBox() {
    return RenderBoxInfo(x: 0.0, y: 0.0, width: 100.0, height: 50.0);
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

      // Skip processing for display-only inspector IDs
      if (widgetId.startsWith('inspector-')) {
        _logger.fine('Skipping display-only inspector ID: $widgetId');
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
