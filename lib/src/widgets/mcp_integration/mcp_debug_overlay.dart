import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../services/mcp_service.dart';

/// Debug overlay widget for MCP integration that provides screenshot and inspection capabilities
class McpDebugOverlay extends StatefulWidget {
  final Widget child;
  final bool enabled;

  const McpDebugOverlay({super.key, required this.child, this.enabled = true});

  @override
  State<McpDebugOverlay> createState() => _McpDebugOverlayState();
}

class _McpDebugOverlayState extends State<McpDebugOverlay> {
  McpService? _mcpService;
  bool _showDebugPanel = false;
  String _lastAction = 'None';
  Map<String, dynamic>? _lastResult;

  @override
  void initState() {
    super.initState();
    try {
      _mcpService = GetIt.instance<McpService>();
    } catch (e) {
      // MCP service not available, debug overlay will be disabled
      debugPrint('MCP service not available in this environment: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled || _mcpService == null) {
      return widget.child;
    }

    return Stack(
      children: [
        widget.child,
        if (_showDebugPanel) _buildDebugPanel(),
        _buildFloatingActionButton(),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      right: 16,
      child: FloatingActionButton.small(
        onPressed: () {
          setState(() {
            _showDebugPanel = !_showDebugPanel;
          });
        },
        backgroundColor: Colors.deepPurple,
        child: Icon(
          _showDebugPanel ? Icons.close : Icons.developer_mode,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDebugPanel() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 80,
      right: 16,
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'MCP Debug Panel',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildActionButton(
              'Take Screenshot',
              Icons.camera_alt,
              _takeScreenshot,
            ),
            const SizedBox(height: 8),
            _buildActionButton('Get View Details', Icons.info, _getViewDetails),
            const SizedBox(height: 8),
            _buildActionButton(
              'Trigger Hot Reload',
              Icons.refresh,
              _triggerHotReload,
            ),
            const SizedBox(height: 8),
            _buildActionButton('Get App Errors', Icons.error, _getAppErrors),
            const SizedBox(height: 16),
            Text(
              'Last Action: $_lastAction',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            if (_lastResult != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _formatResult(_lastResult!),
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 10,
                    fontFamily: 'monospace',
                  ),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
    );
  }

  Future<void> _takeScreenshot() async {
    if (_mcpService == null) return;
    
    setState(() {
      _lastAction = 'Taking Screenshot...';
    });

    try {
      final screenshot = await _mcpService!.takeScreenshot();
      setState(() {
        _lastAction = 'Screenshot Taken';
        _lastResult = {
          'success': screenshot != null,
          'size': screenshot?.length ?? 0,
          'format': 'PNG',
          'timestamp': DateTime.now().toIso8601String(),
        };
      });
    } catch (e) {
      setState(() {
        _lastAction = 'Screenshot Failed';
        _lastResult = {'error': e.toString()};
      });
    }
  }

  Future<void> _getViewDetails() async {
    if (_mcpService == null) return;
    
    setState(() {
      _lastAction = 'Getting View Details...';
    });

    try {
      final details = _mcpService!.getViewDetails();
      setState(() {
        _lastAction = 'View Details Retrieved';
        _lastResult = details;
      });
    } catch (e) {
      setState(() {
        _lastAction = 'View Details Failed';
        _lastResult = {'error': e.toString()};
      });
    }
  }

  Future<void> _triggerHotReload() async {
    if (_mcpService == null) return;
    
    setState(() {
      _lastAction = 'Triggering Hot Reload...';
    });

    try {
      await _mcpService!.triggerHotReload();
      setState(() {
        _lastAction = 'Hot Reload Triggered';
        _lastResult = {
          'success': true,
          'timestamp': DateTime.now().toIso8601String(),
        };
      });
    } catch (e) {
      setState(() {
        _lastAction = 'Hot Reload Failed';
        _lastResult = {'error': e.toString()};
      });
    }
  }

  Future<void> _getAppErrors() async {
    if (_mcpService == null) return;
    
    setState(() {
      _lastAction = 'Getting App Errors...';
    });

    try {
      final errors = _mcpService!.getAppErrors();
      setState(() {
        _lastAction = 'App Errors Retrieved';
        _lastResult = {
          'errorCount': errors.length,
          'errors': errors.take(3).toList(), // Show first 3 errors
          'timestamp': DateTime.now().toIso8601String(),
        };
      });
    } catch (e) {
      setState(() {
        _lastAction = 'Get Errors Failed';
        _lastResult = {'error': e.toString()};
      });
    }
  }

  String _formatResult(Map<String, dynamic> result) {
    final buffer = StringBuffer();
    result.forEach((key, value) {
      buffer.writeln('$key: ${value.toString()}');
    });
    return buffer.toString();
  }
}
