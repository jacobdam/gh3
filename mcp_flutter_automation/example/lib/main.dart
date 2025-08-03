import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'dart:convert';
import 'extensions/mcp_screenshot_extension.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final GlobalKey repaintBoundaryKey = GlobalKey();

  MCPScreenshotExtension.initialize(repaintBoundaryKey: repaintBoundaryKey);

  // Register custom widget tree extension
  _registerWidgetTreeExtension();

  runApp(MCPFlutterExample(repaintBoundaryKey: repaintBoundaryKey));
}

/// Register custom service extension for full widget tree traversal
void _registerWidgetTreeExtension() {
  try {
    developer.log('Registering custom widget tree extension',
        name: 'MCPWidgetTree');

    // Simple test extension first
    developer.registerExtension('ext.mcp.test', (method, parameters) async {
      developer.log('TEST EXTENSION CALLED!', name: 'MCPWidgetTree');
      final response = {'success': true, 'message': 'Test extension working!'};
      return developer.ServiceExtensionResponse.result(json.encode(response));
    });

    // Full widget tree extension
    developer.registerExtension('ext.mcp.getFullWidgetTree',
        (method, parameters) async {
      try {
        developer.log('FULL WIDGET TREE EXTENSION CALLED!',
            name: 'MCPWidgetTree');

        final widgets = <Map<String, dynamic>>[];
        final binding = WidgetsBinding.instance;

        developer.log('Got WidgetsBinding instance', name: 'MCPWidgetTree');

        if (binding.rootElement != null) {
          developer.log('Starting element tree traversal',
              name: 'MCPWidgetTree');
          _traverseElementTree(binding.rootElement!, widgets, 0);
          developer.log(
              'Completed element tree traversal, found ${widgets.length} widgets',
              name: 'MCPWidgetTree');
        } else {
          developer.log('No rootElement found', name: 'MCPWidgetTree');
        }

        final response = {
          'success': true,
          'widgets': widgets,
          'totalCount': widgets.length,
          'method': 'full_element_traversal',
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        };

        developer.log('Returning response with ${widgets.length} widgets',
            name: 'MCPWidgetTree');
        return developer.ServiceExtensionResponse.result(json.encode(response));
      } catch (e, stackTrace) {
        developer.log('Widget tree extension error: $e',
            name: 'MCPWidgetTree', error: e, stackTrace: stackTrace);

        final errorResponse = {
          'success': false,
          'error': e.toString(),
          'method': 'full_element_traversal',
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        };

        return developer.ServiceExtensionResponse.result(
            json.encode(errorResponse));
      }
    });

    developer.log('✅ Custom widget tree extensions registered successfully!',
        name: 'MCPWidgetTree');
  } catch (e, stackTrace) {
    developer.log('❌ Failed to register custom extensions: $e',
        name: 'MCPWidgetTree', error: e, stackTrace: stackTrace);
  }
}

/// Recursively traverse the element tree and extract widget information
void _traverseElementTree(
    Element element, List<Map<String, dynamic>> widgets, int depth) {
  try {
    // Extract widget info from element
    final widget = element.widget;
    final widgetInfo = {
      'id': 'element-$depth-${element.hashCode}',
      'type': widget.runtimeType.toString(),
      'depth': depth,
      'elementType': element.runtimeType.toString(),
      'key': widget.key?.toString(),
      'isStateful': element is StatefulElement,
      'bounds': _tryGetBounds(element),
    };

    widgets.add(widgetInfo);
    developer.log('Found widget: ${widget.runtimeType} at depth $depth',
        name: 'MCPWidgetTree');

    // Traverse children
    element.visitChildren((child) {
      _traverseElementTree(child, widgets, depth + 1);
    });
  } catch (e) {
    developer.log('Error traversing element at depth $depth: $e',
        name: 'MCPWidgetTree');
  }
}

/// Try to get bounds from element's render object
Map<String, double>? _tryGetBounds(Element element) {
  try {
    final renderObject = element.renderObject;
    if (renderObject is RenderBox && renderObject.hasSize) {
      final size = renderObject.size;
      final offset = renderObject.localToGlobal(Offset.zero);
      return {
        'x': offset.dx,
        'y': offset.dy,
        'width': size.width,
        'height': size.height,
      };
    }
  } catch (e) {
    // Ignore bounds extraction errors
  }
  return null;
}

class MCPFlutterExample extends StatelessWidget {
  final GlobalKey repaintBoundaryKey;

  const MCPFlutterExample({
    super.key,
    required this.repaintBoundaryKey,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MCP Flutter Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MCPRepaintBoundary(
        repaintBoundaryKey: repaintBoundaryKey,
        child: const SimpleToggleScreen(),
      ),
    );
  }
}

class SimpleToggleScreen extends StatefulWidget {
  const SimpleToggleScreen({super.key});

  @override
  State<SimpleToggleScreen> createState() => _SimpleToggleScreenState();
}

class _SimpleToggleScreenState extends State<SimpleToggleScreen> {
  bool _showFirstText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('MCP Flutter Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _showFirstText ? 'Hello MCP!' : 'Text Toggled!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _showFirstText = !_showFirstText;
                });
              },
              child: const Text('Toggle Text'),
            ),
          ],
        ),
      ),
    );
  }
}
