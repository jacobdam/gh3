# TASK-004: Implement configurable timeout system (Phase 1)

## Objective
Enhance the existing TimeoutManager with configurable timeout system supporting runtime configuration and dynamic timeout adjustment.

## Background
Building on TASK-001 (TimeoutManager) completed in Phase 0, we now enhance the clean architecture with advanced timeout configuration capabilities to support different deployment environments and operation types that may require custom timeout values.

**Phase:** 1 - Foundation Enhancement (moved from Phase 0)
**Dependencies:** TASK-001 (TimeoutManager) ✅ COMPLETED

## Requirements
1. Extend TimeoutManager with:
   - Runtime timeout configuration
   - Environment-based timeout profiles
   - Dynamic timeout adjustment during operation
   - Configuration validation and fallbacks
   - Hot-reload of timeout configurations

2. Configuration sources:
   - Environment variables
   - Configuration files (JSON/YAML)
   - Runtime API calls
   - Default fallback values

## Technical Specifications
Reference: `docs/technical-design.md` - Section 3.1: Configurable Timeouts

```dart
class ConfigurableTimeoutManager extends TimeoutManager {
  Map<String, Duration> _runtimeTimeouts = {};
  String? _configSource;
  
  void loadConfiguration(String source); // file path or env prefix
  void updateTimeout(String method, Duration timeout);
  void setTimeoutProfile(String profileName);
  Duration getEffectiveTimeout(String method);
  Map<String, Duration> getAllTimeouts();
  void resetToDefaults();
  bool validateConfiguration(Map<String, dynamic> config);
}

enum TimeoutProfile {
  development,  // Shorter timeouts for faster feedback
  production,   // Longer timeouts for stability
  testing,      // Very short timeouts for test speed
  custom        // User-defined profile
}
```

## Configuration Format
```json
{
  "timeout_profile": "production",
  "method_timeouts": {
    "initialize": "15s",
    "tools/call": "5m",
    "custom/long_operation": "10m"
  },
  "global_multiplier": 1.5,
  "max_timeout": "15m"
}
```

## Acceptance Criteria
- [ ] ConfigurableTimeoutManager extends existing TimeoutManager
- [ ] Support for JSON/YAML configuration files
- [ ] Environment variable configuration (MCP_TIMEOUT_*)
- [ ] Runtime timeout updates via API
- [ ] Timeout profile system (dev/prod/test/custom)
- [ ] Configuration validation with helpful error messages
- [ ] Hot-reload configuration without restart
- [ ] Backward compatibility with existing TimeoutManager
- [ ] Comprehensive unit tests with >90% coverage
- [ ] Integration tests with various configuration sources
- [ ] No breaking changes to existing functionality

## Implementation Steps
1. Extend TimeoutManager to ConfigurableTimeoutManager
2. Write unit tests for configuration loading (TDD approach)
3. Implement JSON/YAML configuration parsing
4. Add environment variable support
5. Implement timeout profile system
6. Add runtime configuration update API
7. Implement hot-reload functionality
8. Add configuration validation
9. Integrate with MCPDevProxy
10. Run integration tests
11. Update documentation and examples

## Testing Checklist
- [ ] Unit tests for all configuration sources
- [ ] Edge cases: invalid configs, missing files, malformed JSON
- [ ] Configuration validation tests
- [ ] Hot-reload functionality tests
- [ ] Profile switching tests
- [ ] Runtime update tests
- [ ] Integration with existing timeout functionality
- [ ] Performance impact tests (config overhead < 1ms)

## Configuration Examples
### Environment Variables
```bash
MCP_TIMEOUT_PROFILE=production
MCP_TIMEOUT_INITIALIZE=15s
MCP_TIMEOUT_TOOLS_CALL=300s
MCP_TIMEOUT_GLOBAL_MULTIPLIER=1.2
```

### Configuration File
```yaml
timeout_profile: production
method_timeouts:
  initialize: 15s
  tools/call: 5m
  resources/list: 30s
global_multiplier: 1.0
max_timeout: 15m
```

## Notes
- Ensure thread-safe configuration updates
- Handle configuration file watching for hot-reload
- Support both relative and absolute timeout values
- Provide clear error messages for invalid configurations
- Consider configuration migration for version updates