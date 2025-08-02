import 'package:flutter/material.dart';
import 'extensions/mcp_screenshot_extension.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final GlobalKey repaintBoundaryKey = GlobalKey();

  MCPScreenshotExtension.initialize(repaintBoundaryKey: repaintBoundaryKey);

  runApp(MCPFlutterExample(repaintBoundaryKey: repaintBoundaryKey));
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
