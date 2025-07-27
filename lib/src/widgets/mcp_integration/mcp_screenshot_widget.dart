import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../services/mcp_service.dart';

/// Widget for taking screenshots and integrating with MCP tools
class McpScreenshotWidget extends StatefulWidget {
  final VoidCallback? onScreenshotTaken;
  final bool showPreview;
  final IconData icon;
  final String tooltip;

  const McpScreenshotWidget({
    super.key,
    this.onScreenshotTaken,
    this.showPreview = false,
    this.icon = Icons.camera_alt,
    this.tooltip = 'Take Screenshot for AI Analysis',
  });

  @override
  State<McpScreenshotWidget> createState() => _McpScreenshotWidgetState();
}

class _McpScreenshotWidgetState extends State<McpScreenshotWidget> {
  McpService? _mcpService;
  bool _isCapturing = false;
  String? _lastScreenshotPath;

  @override
  void initState() {
    super.initState();
    try {
      _mcpService = GetIt.instance<McpService>();
    } catch (e) {
      // MCP service not available
      debugPrint('MCP service not available for screenshot widget: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: (_isCapturing || _mcpService == null) ? null : _takeScreenshot,
          icon: _isCapturing
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(widget.icon),
          tooltip: widget.tooltip,
        ),
        if (widget.showPreview && _lastScreenshotPath != null) ...[
          const SizedBox(height: 8),
          Container(
            width: 100,
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Center(
              child: Text(
                'Screenshot\nCaptured',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _takeScreenshot() async {
    if (_mcpService == null) return;
    
    setState(() {
      _isCapturing = true;
    });

    try {
      final screenshot = await _mcpService!.takeScreenshot();

      if (screenshot != null) {
        setState(() {
          _lastScreenshotPath =
              'screenshot_${DateTime.now().millisecondsSinceEpoch}.png';
        });

        widget.onScreenshotTaken?.call();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Screenshot captured for AI analysis'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to capture screenshot: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      setState(() {
        _isCapturing = false;
      });
    }
  }
}
