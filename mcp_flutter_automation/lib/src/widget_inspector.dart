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
          _logger.info('Processing widget tree from result wrapper');
          await _processSimpleWidgetNode(appId, result, widgets);
        }
      } else {
        _logger.info('Processing widget tree directly');
        await _processSimpleWidgetNode(appId, widgetTreeData, widgets);
      }
      
      _logger.info('Completed widget tree processing. Total widgets found: ${widgets.length}');
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

      // Check if this is an app-specific widget (created by local project)
      final isLocalWidget = node['createdByLocalProject'] == true;
      final logLevel = isLocalWidget ? 'INFO' : 'FINE';
      
      _logger.info('[$logLevel] Processing widget #${widgets.length + 1}: $widgetType (ID: $widgetId) ${isLocalWidget ? '[LOCAL APP WIDGET]' : '[FRAMEWORK WIDGET]'}');

      // Always create widget info, even without render box bounds
      final widgetInfo = WidgetInfo(
        id: widgetId,
        type: widgetType,
        properties: _extractPropertiesFromNode(node),
        renderBox: _createDefaultRenderBox(), // Provide default bounds for now
      );

      widgets.add(widgetInfo);
      _logger.info('Added widget to list: $widgetType (ID: $widgetId) - Total widgets: ${widgets.length}');

      // Process children recursively
      final children = node['children'] as List?;
      final hasChildren = node['hasChildren'] as bool? ?? false;
      
      if (children != null) {
        _logger.info('Widget $widgetType has ${children.length} child nodes - continuing traversal');
        for (final child in children) {
          if (child is Map<String, dynamic>) {
            await _processSimpleWidgetNode(appId, child, widgets);
          }
        }
      } else if (hasChildren) {
        // Widget has children but they're not in the tree - try to get them separately
        _logger.info('Widget $widgetType has children but they are not loaded - attempting deep traversal');
        await _getChildrenForWidget(appId, widgetId, widgets);
      } else {
        _logger.info('Widget $widgetType has no children - end of branch');
      }
    } catch (e) {
      _logger.warning('Error processing simple widget node: $e');
    }
  }

  /// Attempts to get children of a specific widget using Flutter Inspector
  Future<void> _getChildrenForWidget(String appId, String widgetId, List<WidgetInfo> widgets) async {
    try {
      _logger.info('Attempting to get children for widget: $widgetId');
      
      final app = _controller.getAppInstance(appId);
      if (app?.vmService == null || app?.isolateId == null) {
        _logger.warning('No VM service available for child widget lookup');
        return;
      }

      // Try different Flutter Inspector methods to get widget children
      final methods = [
        'ext.flutter.inspector.getDetailsSubtree',
        'ext.flutter.inspector.getProperties', 
        'ext.flutter.inspector.getChildrenDetailsSubtree',
      ];

      for (final method in methods) {
        try {
          _logger.info('Trying $method to get children of $widgetId');
          
          final response = await app!.vmService!.callServiceExtension(
            method,
            isolateId: app.isolateId,
            args: {
              'objectId': widgetId,
              'objectGroup': 'inspector',
            },
          );

          final result = response.json;
          if (result != null) {
            _logger.info('Got result from $method, processing children...');
            
            // Look for children in the response
            final children = result['children'] as List?;
            if (children != null && children.isNotEmpty) {
              _logger.info('Found ${children.length} children using $method');
              for (final child in children) {
                if (child is Map<String, dynamic>) {
                  await _processSimpleWidgetNode(appId, child, widgets);
                }
              }
              return; // Success - stop trying other methods
            }
            
            // If no direct children, check if this is a subtree response
            if (result.containsKey('children') || result.containsKey('result')) {
              final subtree = result['result'] ?? result;
              if (subtree is Map<String, dynamic>) {
                await _processSimpleWidgetNode(appId, subtree, widgets);
                return; // Success
              }
            }
          }
        } catch (e) {
          _logger.fine('Method $method failed for widget $widgetId: $e');
          continue;
        }
      }
      
      _logger.warning('Could not get children for widget $widgetId using any method');
    } catch (e) {
      _logger.warning('Error getting children for widget $widgetId: $e');
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
