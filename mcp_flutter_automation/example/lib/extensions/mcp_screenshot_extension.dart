import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class MCPScreenshotExtension {
  static bool _isRegistered = false;
  static GlobalKey? _repaintBoundaryKey;

  static void initialize({GlobalKey? repaintBoundaryKey}) {
    if (_isRegistered) return;

    _repaintBoundaryKey = repaintBoundaryKey;
    _registerExtensions();
    _isRegistered = true;

    developer.log('MCP Screenshot Extension initialized', name: 'MCPExtension');
  }

  static void _registerExtensions() {
    developer.registerExtension('ext.gh3.screenshot',
        (method, parameters) async {
      try {
        developer.log('Screenshot extension called', name: 'MCPExtension');

        final screenshot = await _captureScreenshot();

        if (screenshot != null) {
          final response = {
            'success': true,
            'screenshot': screenshot,
            'format': 'png',
            'method': 'RenderRepaintBoundary',
            'timestamp': DateTime.now().millisecondsSinceEpoch,
          };

          developer.log(
              'Screenshot captured successfully, size: ${screenshot.length}',
              name: 'MCPExtension');

          return developer.ServiceExtensionResponse.result(
              json.encode(response));
        } else {
          throw Exception('Failed to capture screenshot');
        }
      } catch (e, stackTrace) {
        developer.log('Screenshot extension error: $e',
            name: 'MCPExtension', error: e, stackTrace: stackTrace);

        final errorResponse = {
          'success': false,
          'error': e.toString(),
          'method': 'RenderRepaintBoundary',
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        };

        return developer.ServiceExtensionResponse.result(
            json.encode(errorResponse));
      }
    });

    developer.registerExtension('ext.gh3.test', (method, parameters) async {
      developer.log('Test extension called', name: 'MCPExtension');

      final response = {
        'success': true,
        'message': 'MCP Flutter Extension is working!',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'repaintBoundaryKey':
            _repaintBoundaryKey != null ? 'available' : 'not_set',
      };

      return developer.ServiceExtensionResponse.result(json.encode(response));
    });

    developer.log('MCP extensions registered: ext.gh3.screenshot, ext.gh3.test',
        name: 'MCPExtension');
  }

  static Future<String?> _captureScreenshot() async {
    try {
      RenderRepaintBoundary? boundary;

      if (_repaintBoundaryKey != null) {
        final context = _repaintBoundaryKey!.currentContext;
        if (context != null) {
          boundary = context.findRenderObject() as RenderRepaintBoundary?;
          developer.log('Using provided RepaintBoundary key',
              name: 'MCPExtension');
        }
      }

      boundary ??= _findRootRepaintBoundary();

      if (boundary == null) {
        throw Exception('No RepaintBoundary found for screenshot');
      }

      developer.log('Capturing screenshot from RepaintBoundary',
          name: 'MCPExtension');

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        throw Exception('Failed to convert image to byte data');
      }

      final Uint8List pngBytes = byteData.buffer.asUint8List();
      final String base64String = base64Encode(pngBytes);

      developer.log(
          'Screenshot converted to base64, size: ${base64String.length}',
          name: 'MCPExtension');

      return base64String;
    } catch (e) {
      developer.log('Screenshot capture failed: $e', name: 'MCPExtension');
      rethrow;
    }
  }

  static RenderRepaintBoundary? _findRootRepaintBoundary() {
    try {
      final RenderView? renderView =
          WidgetsBinding.instance.renderViews.firstOrNull;
      if (renderView == null) return null;

      RenderObject? current = renderView.child;
      while (current != null) {
        if (current is RenderRepaintBoundary) {
          developer.log('Found root RepaintBoundary', name: 'MCPExtension');
          return current;
        }
        if (current is RenderObjectWithChildMixin) {
          current = current.child;
        } else {
          break;
        }
      }

      developer.log('No root RepaintBoundary found', name: 'MCPExtension');
      return null;
    } catch (e) {
      developer.log('Error finding root RepaintBoundary: $e',
          name: 'MCPExtension');
      return null;
    }
  }
}

class MCPRepaintBoundary extends StatelessWidget {
  final Widget child;
  final GlobalKey repaintBoundaryKey;

  const MCPRepaintBoundary({
    super.key,
    required this.child,
    required this.repaintBoundaryKey,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: repaintBoundaryKey,
      child: child,
    );
  }
}
