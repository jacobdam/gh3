import 'package:flutter/material.dart';
import 'package:gh3/src/init.dart';
import 'package:gh3/src/screens/app/gh3_app.dart';
import 'package:gh3/src/screens/app/auth_viewmodel.dart';
import 'package:gh3/src/routing/route_collection_service.dart';
import 'package:gh3/src/services/mcp_service.dart';
import 'package:gh3/src/services/mcp_github_tools.dart';
import 'package:gh3/src/services/mcp_development_workflow.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();

  // Get services from dependency injection
  final authVM = getIt<AuthViewModel>();
  final routeCollectionService = getIt<RouteCollectionService>();

  // Initialize MCP services for AI agent development
  final mcpService = getIt<McpService>();
  final mcpGitHubTools = getIt<McpGitHubTools>();
  final mcpWorkflow = getIt<McpDevelopmentWorkflow>();

  // Initialize services
  authVM.init();

  try {
    await mcpService.initialize();
    await mcpGitHubTools.initialize();
    await mcpWorkflow.initialize();
    debugPrint('MCP services initialized successfully');
  } catch (e) {
    debugPrint('Failed to initialize MCP services: $e');
    // Continue without MCP if initialization fails
  }

  runApp(
    Gh3App(
      authViewModel: authVM,
      routeCollectionService: routeCollectionService,
    ),
  );
}
