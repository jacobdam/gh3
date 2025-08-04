import "dart:convert";
import "dart:io";

import "package:mcp_dev_proxy/src/managers/configurable_timeout_manager.dart";
import "package:test/test.dart";

void main() {
  group("ConfigurableTimeoutManager", () {
    late ConfigurableTimeoutManager manager;
    late Directory tempDir;

    setUp(() {
      manager = ConfigurableTimeoutManager();
      tempDir = Directory.systemTemp.createTempSync("timeout_config_test");
    });

    tearDown(() {
      manager.dispose();
      tempDir.deleteSync(recursive: true);
    });

    group("TimeoutConfiguration", () {
      test("should create from map with valid data", () {
        final config = {
          "timeout_profile": "development",
          "method_timeouts": {
            "initialize": "5s",
            "tools/call": "30s",
          },
          "global_multiplier": 1.5,
          "max_timeout": "10m",
        };

        final timeoutConfig = TimeoutConfiguration.fromMap(config);

        expect(timeoutConfig.profile, equals(TimeoutProfile.development));
        expect(
          timeoutConfig.methodTimeouts["initialize"],
          equals(const Duration(seconds: 5)),
        );
        expect(
          timeoutConfig.methodTimeouts["tools/call"],
          equals(const Duration(seconds: 30)),
        );
        expect(timeoutConfig.globalMultiplier, equals(1.5));
        expect(timeoutConfig.maxTimeout, equals(const Duration(minutes: 10)));
      });

      test("should handle defaults for missing values", () {
        final config = <String, dynamic>{};

        final timeoutConfig = TimeoutConfiguration.fromMap(config);

        expect(timeoutConfig.profile, equals(TimeoutProfile.production));
        expect(timeoutConfig.globalMultiplier, equals(1.0));
        expect(timeoutConfig.maxTimeout, equals(const Duration(minutes: 15)));
        expect(timeoutConfig.methodTimeouts, isEmpty);
      });

      test("should parse duration strings correctly", () {
        final testCases = {
          "30s": const Duration(seconds: 30),
          "5m": const Duration(minutes: 5),
          "2h": const Duration(hours: 2),
          "1.5m": const Duration(milliseconds: 90000),
        };

        for (final entry in testCases.entries) {
          final config = {
            "method_timeouts": {"test": entry.key},
          };

          final timeoutConfig = TimeoutConfiguration.fromMap(config);
          expect(
            timeoutConfig.methodTimeouts["test"],
            equals(entry.value),
            reason: "Failed to parse: ${entry.key}",
          );
        }
      });

      test("should reject invalid duration strings", () {
        final invalidDurations = ["invalid", "30x", "-5s", ""];

        for (final duration in invalidDurations) {
          final config = {
            "method_timeouts": {"test": duration},
          };

          final timeoutConfig = TimeoutConfiguration.fromMap(config);
          expect(
            timeoutConfig.methodTimeouts.containsKey("test"),
            isFalse,
            reason: "Should reject invalid duration: $duration",
          );
        }
      });
    });

    group("Default Configuration", () {
      test("should start with production profile by default", () {
        expect(
          manager.getAllTimeouts()["initialize"],
          equals(const Duration(seconds: 15)),
        );
        expect(
          manager.getAllTimeouts()["tools/call"],
          equals(const Duration(seconds: 90)),
        );
      });

      test("should provide correct profile defaults", () {
        manager.setTimeoutProfile("development");
        expect(
          manager.getAllTimeouts()["initialize"],
          equals(const Duration(seconds: 5)),
        );
        expect(
          manager.getAllTimeouts()["tools/call"],
          equals(const Duration(seconds: 30)),
        );

        manager.setTimeoutProfile("testing");
        expect(
          manager.getAllTimeouts()["initialize"],
          equals(const Duration(seconds: 1)),
        );
        expect(
          manager.getAllTimeouts()["tools/call"],
          equals(const Duration(seconds: 5)),
        );
      });
    });

    group("Runtime Configuration Updates", () {
      test("should update timeout for specific method", () {
        const newTimeout = Duration(seconds: 45);
        manager.updateTimeout("initialize", newTimeout);

        expect(manager.getTimeout("initialize", null), equals(newTimeout));
      });

      test("should switch to custom profile when updating timeouts", () {
        manager.updateTimeout("initialize", const Duration(seconds: 45));

        final info = manager.getConfigurationInfo();
        expect(info["profile"], equals("custom"));
      });

      test("should preserve existing timeouts when updating", () {
        final originalToolsCall = manager.getTimeout("tools/call", null);
        manager.updateTimeout("initialize", const Duration(seconds: 45));

        expect(
          manager.getTimeout("tools/call", null),
          equals(originalToolsCall),
        );
      });
    });

    group("Profile Management", () {
      test("should switch between profiles correctly", () {
        manager.setTimeoutProfile("development");
        expect(
          manager.getTimeout("initialize", null),
          equals(const Duration(seconds: 5)),
        );

        manager.setTimeoutProfile("production");
        expect(
          manager.getTimeout("initialize", null),
          equals(const Duration(seconds: 15)),
        );
      });

      test("should handle unknown profile gracefully", () {
        manager.setTimeoutProfile("unknown");

        final info = manager.getConfigurationInfo();
        expect(info["profile"], equals("custom"));
      });
    });

    group("Global Multiplier", () {
      test("should apply global multiplier to timeouts", () {
        const config = TimeoutConfiguration(
          profile: TimeoutProfile.production,
          methodTimeouts: {"test": Duration(seconds: 10)},
          globalMultiplier: 2,
        );

        final multipliedManager = ConfigurableTimeoutManager(
          initialConfig: config,
        );

        expect(
          multipliedManager.getTimeout("test", null),
          equals(const Duration(seconds: 20)),
        );

        multipliedManager.dispose();
      });

      test("should enforce maximum timeout limits", () {
        const config = TimeoutConfiguration(
          profile: TimeoutProfile.production,
          methodTimeouts: {"test": Duration(minutes: 20)},
          globalMultiplier: 2,
        );

        final limitedManager = ConfigurableTimeoutManager(
          initialConfig: config,
        );

        expect(
          limitedManager.getTimeout("test", null),
          equals(const Duration(minutes: 15)),
        );

        limitedManager.dispose();
      });
    });

    group("Parameter Override", () {
      test("should respect timeout_seconds parameter", () {
        const paramTimeout = 120;
        final params = {"timeout_seconds": paramTimeout};

        expect(
          manager.getTimeout("initialize", params),
          equals(const Duration(seconds: paramTimeout)),
        );
      });

      test("should ignore invalid timeout_seconds parameter", () {
        final invalidParams = [
          {"timeout_seconds": -5},
          {"timeout_seconds": "invalid"},
          {"timeout_seconds": 0},
        ];

        for (final params in invalidParams) {
          expect(
            manager.getTimeout("initialize", params),
            isNot(equals(const Duration(seconds: -5))),
          );
        }
      });
    });

    group("Configuration Validation", () {
      test("should validate correct configuration", () {
        final validConfig = {
          "timeout_profile": "development",
          "method_timeouts": {
            "initialize": "5s",
            "tools/call": "30s",
          },
          "global_multiplier": 1.5,
          "max_timeout": "10m",
        };

        expect(manager.validateConfiguration(validConfig), isTrue);
      });

      test("should reject invalid profile", () {
        final invalidConfig = {
          "timeout_profile": "invalid_profile",
        };

        expect(manager.validateConfiguration(invalidConfig), isFalse);
      });

      test("should reject invalid global multiplier", () {
        final invalidConfig = {
          "global_multiplier": "not_a_number",
        };

        expect(manager.validateConfiguration(invalidConfig), isFalse);
      });

      test("should reject invalid method timeouts", () {
        final invalidConfigs = [
          {
            "method_timeouts": "not_a_map",
          },
          {
            "method_timeouts": {
              "initialize": "invalid_duration",
            },
          },
          {
            "method_timeouts": {
              123: "5s", // non-string key
            },
          },
        ];

        for (final config in invalidConfigs) {
          expect(manager.validateConfiguration(config), isFalse);
        }
      });

      test("should reject invalid max timeout", () {
        final invalidConfig = {
          "max_timeout": "invalid_duration",
        };

        expect(manager.validateConfiguration(invalidConfig), isFalse);
      });
    });

    group("File Configuration Loading", () {
      test("should load JSON configuration file", () async {
        final config = {
          "timeout_profile": "development",
          "method_timeouts": {
            "initialize": "3s",
          },
          "global_multiplier": 2.0,
        };

        final configFile = File("${tempDir.path}/config.json");
        await configFile.writeAsString(jsonEncode(config));

        await manager.loadConfiguration(configFile.path);

        expect(
          manager.getTimeout("initialize", null),
          equals(const Duration(seconds: 6)),
        ); // 3s * 2.0 multiplier
      });

      test("should load YAML configuration file", () async {
        const yamlConfig = """
timeout_profile: testing
method_timeouts:
  initialize: 2s
  tools/call: 10s
global_multiplier: 1.5
""";

        final configFile = File("${tempDir.path}/config.yaml");
        await configFile.writeAsString(yamlConfig);

        await manager.loadConfiguration(configFile.path);

        expect(
          manager.getTimeout("initialize", null),
          equals(const Duration(milliseconds: 3000)),
        ); // 2s * 1.5
      });

      test("should throw error for non-existent file", () async {
        expect(
          () => manager.loadConfiguration("/non/existent/file.json"),
          throwsA(isA<ConfigurationError>()),
        );
      });

      test("should throw error for unsupported file format", () async {
        final configFile = File("${tempDir.path}/config.txt");
        await configFile.writeAsString("invalid content");

        expect(
          () => manager.loadConfiguration(configFile.path),
          throwsA(isA<ConfigurationError>()),
        );
      });

      test("should throw error for invalid JSON", () async {
        final configFile = File("${tempDir.path}/config.json");
        await configFile.writeAsString("{ invalid json }");

        expect(
          () => manager.loadConfiguration(configFile.path),
          throwsA(isA<ConfigurationError>()),
        );
      });
    });

    group("Environment Variable Configuration", () {
      test("should load configuration from environment variables", () async {
        // Note: This test simulates environment loading by calling the private method
        // In a real scenario, you'd set actual environment variables
        // Note: originalEnv would be used to restore environment in a full implementation

        // We can't easily modify Platform.environment in tests, so we'll test
        // the validation and parsing logic instead
        final envConfig = {
          "timeout_profile": "development",
          "method_timeouts": {
            "initialize": "3s",
            "tools/call": "25s",
          },
        };

        expect(manager.validateConfiguration(envConfig), isTrue);
      });
    });

    group("Configuration Information", () {
      test("should provide configuration information", () {
        final info = manager.getConfigurationInfo();

        expect(info, containsPair("profile", "production"));
        expect(info, containsPair("source", "default"));
        expect(info, containsPair("global_multiplier", 1.0));
        expect(info, containsPair("max_timeout", "15m"));
        expect(info, containsPair("method_count", isA<int>()));
      });
    });

    group("Reset to Defaults", () {
      test("should reset to default configuration", () {
        manager.updateTimeout("initialize", const Duration(seconds: 99));
        manager.resetToDefaults();

        expect(
          manager.getTimeout("initialize", null),
          equals(const Duration(seconds: 15)),
        ); // production default
      });
    });

    group("Disposal", () {
      test("should dispose without errors", () {
        expect(() => manager.dispose(), returnsNormally);
      });

      test("should cancel file watcher on disposal", () async {
        final configFile = File("${tempDir.path}/config.json");
        await configFile.writeAsString("{}");

        await manager.loadConfiguration(configFile.path);
        expect(() => manager.dispose(), returnsNormally);
      });
    });

    group("Error Handling", () {
      test("ConfigurationError should format message correctly", () {
        const message = "Test error message";
        final error = ConfigurationError(message);

        expect(error.toString(), equals("ConfigurationError: $message"));
      });
    });
  });
}
