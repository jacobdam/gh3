# Slow Tests Analysis

This document tracks tests that take longer than 1 second to execute, identified on 2025-07-30.

## Test Execution Configuration
- **Reporter**: expanded
- **Concurrency**: 1 (single-threaded)
- **Threshold**: Tests taking ≥1 second

## Top 10 Slowest Tests

### 1. OAuth Device Flow - Slow Down Simulation
- **Duration**: 10 seconds
- **File**: `test/integration/auth_integration_test.dart`
- **Test**: Authentication Integration Tests > OAuth Device Flow Integration > device flow with slow down then success
- **Issue**: Likely contains actual delays to simulate OAuth flow timing
- **Optimization**: Mock delays instead of using real timeouts

### 2. OAuth Device Flow - Authorization Pending
- **Duration**: 5 seconds
- **File**: `test/integration/auth_integration_test.dart`
- **Test**: Authentication Integration Tests > OAuth Device Flow Integration > device flow with authorization pending then success
- **Issue**: Contains delays for authorization pending simulation
- **Optimization**: Mock the pending state without actual delays

### 3. HomeRouteProvider Dependency Injection
- **Duration**: 2 seconds
- **File**: `test/screens/home_screen/home_route_provider_test.dart`
- **Test**: HomeRouteProvider > should inject dependencies correctly into HomeScreen
- **Issue**: Complex dependency setup/teardown
- **Optimization**: Review DI setup, consider test-specific lightweight mocks

### 4. UserStatusCard - Display Status
- **Duration**: 1 second
- **File**: `test/widgets/user_status_card/user_status_card_test.dart`
- **Test**: UserStatusCard > should display status message and emoji when both are provided
- **Issue**: Widget rendering overhead
- **Optimization**: Review widget complexity, consider simpler test setup

### 5. UserStatusCard - Styling Test
- **Duration**: 1 second
- **File**: `test/widgets/user_status_card/user_status_card_test.dart`
- **Test**: UserStatusCard > should apply proper styling and theming
- **Issue**: Theme application and styling verification
- **Optimization**: Consider combining with other styling tests

### 6. UserStatsRow - Zero Formatting
- **Duration**: 1 second
- **File**: `test/widgets/user_stats_row/user_stats_row_test.dart`
- **Test**: UserStatsRow > count formatting > should format zero correctly
- **Issue**: Number formatting logic
- **Optimization**: Review if formatting tests can be unit tested without widgets

### 7. UserCard - Avatar Fallback
- **Duration**: 1 second
- **File**: `test/widgets/user_card/user_card_test.dart`
- **Test**: UserCard > should display avatar fallback with ? if avatarUrl and login are empty
- **Issue**: Avatar rendering and fallback logic
- **Optimization**: Consider testing fallback logic separately from widget

### 8. Basic App Smoke Test
- **Duration**: 1 second
- **File**: `test/widget_test.dart`
- **Test**: Basic app smoke test
- **Issue**: Full app initialization
- **Optimization**: Consider lighter smoke test or move to integration suite

### 9. GHContentMetadata - Mixed Content
- **Duration**: 1 second
- **File**: `test/ui_system/widgets/gh_content_metadata_test.dart`
- **Test**: integration tests > should handle mixed content types appropriately
- **Issue**: Complex content type handling
- **Optimization**: Mock content processing

### 10. GHMetadataChips Display
- **Duration**: 1 second
- **File**: `test/ui_system/widgets/gh_content_metadata_test.dart`
- **Test**: GHMetadataChips > should display chips for metadata items
- **Issue**: Multiple chip rendering
- **Optimization**: Test with minimal chip count

## Optimization Strategies

### High Priority (10s & 5s tests)
1. **Mock OAuth delays** - Replace real timeouts with mocked delays in auth integration tests
2. **Use fake timers** - Implement `FakeAsync` for time-dependent tests

### Medium Priority (2s test)
1. **Optimize DI setup** - Create lightweight test-specific dependency injection
2. **Cache common dependencies** - Reuse setup across related tests

### Low Priority (1s tests)
1. **Widget test optimization** - Reduce widget tree complexity in tests
2. **Combine related tests** - Group similar assertions to reduce setup overhead
3. **Extract logic tests** - Test business logic separately from widgets

## Next Steps
1. Fix auth integration tests by mocking delays (saves ~15s)
2. Optimize dependency injection test setup (saves ~2s)
3. Review widget tests for optimization opportunities
4. Consider parallel test execution for independent test suites

## Total Potential Time Savings
- Current slow test time: ~24 seconds
- Potential optimized time: ~5-7 seconds
- Estimated savings: ~17-19 seconds per test run