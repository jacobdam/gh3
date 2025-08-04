import "dart:async";
import "dart:convert";
import "dart:io";
import "package:yaml/yaml.dart";
import "timeout_manager.dart";

/// Timeout profiles for different deployment environments
enum TimeoutProfile {
  development, // Shorter timeouts for faster feedback
  production, // Longer timeouts for stability
  testing, // Very short timeouts for test speed
  custom // User-defined profile
}

/// Configuration structure for timeout settings
class TimeoutConfiguration {
  const TimeoutConfiguration({
    required this.profile,
    required this.methodTimeouts,
    this.globalMultiplier = 1.0,
    this.maxTimeout = const Duration(minutes: 15),
  });

  /// Create configuration from JSON/Map data
  factory TimeoutConfiguration.fromMap(Map<String, dynamic> config) {
    final profileName = config["timeout_profile"] as String? ?? "production";
    final profile = TimeoutProfile.values.firstWhere(
      (p) => p.name == profileName,
      orElse: () => TimeoutProfile.production,
    );

    final methodTimeouts = <String, Duration>{};
    final methodConfig =
        config["method_timeouts"] as Map<String, dynamic>? ?? {};

    for (final entry in methodConfig.entries) {
      final duration = _parseDuration(entry.value as String);
      if (duration != null) {
        methodTimeouts[entry.key] = duration;
      }
    }

    final globalMultiplier =
        (config["global_multiplier"] as num?)?.toDouble() ?? 1.0;
    final maxTimeoutStr = config["max_timeout"] as String? ?? "15m";
    final maxTimeout =
        _parseDuration(maxTimeoutStr) ?? const Duration(minutes: 15);

    return TimeoutConfiguration(
      profile: profile,
      methodTimeouts: methodTimeouts,
      globalMultiplier: globalMultiplier,
      maxTimeout: maxTimeout,
    );
  }
  final TimeoutProfile profile;
  final Map<String, Duration> methodTimeouts;
  final double globalMultiplier;
  final Duration maxTimeout;

  /// Parse duration string (e.g., "30s", "5m", "1h")
  static Duration? _parseDuration(String value) {
    final regex = RegExp(r"^(\d+(?:\.\d+)?)\s*([smh])$");
    final match = regex.firstMatch(value.toLowerCase());

    if (match == null) return null;

    final number = double.parse(match.group(1)!);
    final unit = match.group(2)!;

    switch (unit) {
      case "s":
        return Duration(milliseconds: (number * 1000).round());
      case "m":
        return Duration(milliseconds: (number * 60 * 1000).round());
      case "h":
        return Duration(milliseconds: (number * 60 * 60 * 1000).round());
      default:
        return null;
    }
  }
}

/// Enhanced TimeoutManager with configurable timeout system
class ConfigurableTimeoutManager extends TimeoutManager {
  ConfigurableTimeoutManager({
    TimeoutConfiguration? initialConfig,
  }) : _config = initialConfig ?? _getDefaultConfiguration();
  TimeoutConfiguration _config;
  String? _configSource;
  StreamSubscription<FileSystemEvent>? _configWatcher;

  /// Profile-specific default configurations
  static const Map<TimeoutProfile, Map<String, Duration>> _profileDefaults = {
    TimeoutProfile.development: {
      "initialize": Duration(seconds: 5),
      "tools/list": Duration(seconds: 3),
      "resources/list": Duration(seconds: 3),
      "prompts/list": Duration(seconds: 3),
      "tools/call": Duration(seconds: 30),
      "_default": Duration(seconds: 10),
    },
    TimeoutProfile.production: {
      "initialize": Duration(seconds: 15),
      "tools/list": Duration(seconds: 10),
      "resources/list": Duration(seconds: 10),
      "prompts/list": Duration(seconds: 10),
      "tools/call": Duration(seconds: 90),
      "_default": Duration(seconds: 30),
    },
    TimeoutProfile.testing: {
      "initialize": Duration(seconds: 1),
      "tools/list": Duration(milliseconds: 500),
      "resources/list": Duration(milliseconds: 500),
      "prompts/list": Duration(milliseconds: 500),
      "tools/call": Duration(seconds: 5),
      "_default": Duration(seconds: 2),
    },
  };

  /// Get default configuration for production profile
  static TimeoutConfiguration _getDefaultConfiguration() {
    return TimeoutConfiguration(
      profile: TimeoutProfile.production,
      methodTimeouts: Map.from(_profileDefaults[TimeoutProfile.production]!),
    );
  }

  /// Load configuration from file path
  Future<void> loadConfiguration(String source) async {
    try {
      _configSource = source;

      if (source.startsWith("env:")) {
        // Load from environment variables
        _loadFromEnvironment(source.substring(4));
      } else {
        // Load from file
        await _loadFromFile(source);
        await _setupFileWatcher(source);
      }
    } catch (e) {
      throw ConfigurationError("Failed to load configuration from $source: $e");
    }
  }

  /// Load configuration from environment variables
  void _loadFromEnvironment(String prefix) {
    final env = Platform.environment;
    final config = <String, dynamic>{};

    // Load profile
    final profileKey = "${prefix}PROFILE";
    if (env.containsKey(profileKey)) {
      config["timeout_profile"] = env[profileKey];
    }

    // Load global multiplier
    final multiplierKey = "${prefix}GLOBAL_MULTIPLIER";
    if (env.containsKey(multiplierKey)) {
      config["global_multiplier"] = double.tryParse(env[multiplierKey]!) ?? 1.0;
    }

    // Load method timeouts
    final methodTimeouts = <String, String>{};
    for (final entry in env.entries) {
      if (entry.key.startsWith(prefix) &&
          !entry.key.endsWith("PROFILE") &&
          !entry.key.endsWith("GLOBAL_MULTIPLIER")) {
        final method = entry.key
            .substring(prefix.length)
            .toLowerCase()
            .replaceAll("_", "/");
        methodTimeouts[method] = entry.value;
      }
    }

    if (methodTimeouts.isNotEmpty) {
      config["method_timeouts"] = methodTimeouts;
    }

    _config = TimeoutConfiguration.fromMap(config);
  }

  /// Convert YAML to Map<String, dynamic>
  Map<String, dynamic> _convertYamlToMap(dynamic yaml) {
    if (yaml is Map) {
      final result = <String, dynamic>{};
      yaml.forEach((key, value) {
        if (key is String) {
          if (value is Map) {
            result[key] = _convertYamlToMap(value);
          } else {
            result[key] = value;
          }
        }
      });
      return result;
    }
    return <String, dynamic>{};
  }

  /// Load configuration from file
  Future<void> _loadFromFile(String filePath) async {
    final file = File(filePath);
    if (!file.existsSync()) {
      throw ConfigurationError("Configuration file not found: $filePath");
    }

    final content = await file.readAsString();
    Map<String, dynamic> config;

    if (filePath.endsWith(".json")) {
      config = jsonDecode(content) as Map<String, dynamic>;
    } else if (filePath.endsWith(".yaml") || filePath.endsWith(".yml")) {
      final yaml = loadYaml(content);
      config = _convertYamlToMap(yaml);
    } else {
      throw ConfigurationError(
        "Unsupported configuration file format. Use .json, .yaml, or .yml",
      );
    }

    if (!validateConfiguration(config)) {
      throw ConfigurationError("Invalid configuration format");
    }

    _config = TimeoutConfiguration.fromMap(config);
  }

  /// Setup file watcher for hot-reload
  Future<void> _setupFileWatcher(String filePath) async {
    unawaited(_configWatcher?.cancel());

    final file = File(filePath);
    _configWatcher = file.watch().listen((event) async {
      if (event.type == FileSystemEvent.modify) {
        try {
          unawaited(_loadFromFile(filePath));
        } on Exception catch (e) {
          // Log error but don't crash - keep existing configuration
          print("Warning: Failed to reload configuration: $e");
        }
      }
    });
  }

  /// Update timeout for specific method at runtime
  void updateTimeout(String method, Duration timeout) {
    final newTimeouts = Map<String, Duration>.from(_config.methodTimeouts);
    newTimeouts[method] = timeout;

    _config = TimeoutConfiguration(
      profile: TimeoutProfile.custom,
      methodTimeouts: newTimeouts,
      globalMultiplier: _config.globalMultiplier,
      maxTimeout: _config.maxTimeout,
    );
  }

  /// Set timeout profile (development/production/testing/custom)
  void setTimeoutProfile(String profileName) {
    final profile = TimeoutProfile.values.firstWhere(
      (p) => p.name == profileName,
      orElse: () => TimeoutProfile.custom,
    );

    Map<String, Duration> baseTimeouts;
    if (profile == TimeoutProfile.custom) {
      baseTimeouts = Map.from(_config.methodTimeouts);
    } else {
      baseTimeouts = Map.from(_profileDefaults[profile]!);
    }

    _config = TimeoutConfiguration(
      profile: profile,
      methodTimeouts: baseTimeouts,
      globalMultiplier: _config.globalMultiplier,
      maxTimeout: _config.maxTimeout,
    );
  }

  /// Get effective timeout for method (with profile and multiplier applied)
  @override
  Duration getTimeout(String method, Map<String, dynamic>? params) {
    // Check for custom timeout in params first (highest priority)
    if (params != null && params.containsKey("timeout_seconds")) {
      final timeoutSeconds = params["timeout_seconds"];
      if (timeoutSeconds is int && timeoutSeconds > 0) {
        return Duration(seconds: timeoutSeconds);
      }
    }

    // Get base timeout from configuration or profile defaults
    Duration baseTimeout;

    if (_config.methodTimeouts.containsKey(method)) {
      baseTimeout = _config.methodTimeouts[method]!;
    } else if (_config.profile != TimeoutProfile.custom) {
      final profileDefaults = _profileDefaults[_config.profile]!;
      baseTimeout = profileDefaults[method] ?? profileDefaults["_default"]!;
    } else {
      // Fallback to parent class implementation
      return super.getTimeout(method, params);
    }

    // Apply global multiplier
    final adjustedTimeout = Duration(
      milliseconds:
          (baseTimeout.inMilliseconds * _config.globalMultiplier).round(),
    );

    // Enforce maximum timeout
    return adjustedTimeout > _config.maxTimeout
        ? _config.maxTimeout
        : adjustedTimeout;
  }

  /// Get all configured timeouts
  Map<String, Duration> getAllTimeouts() {
    final result = <String, Duration>{};

    // Add profile defaults if not custom
    if (_config.profile != TimeoutProfile.custom) {
      result.addAll(_profileDefaults[_config.profile]!);
    }

    // Override with configured timeouts
    result.addAll(_config.methodTimeouts);

    // Apply global multiplier
    for (final entry in result.entries) {
      final adjusted = Duration(
        milliseconds:
            (entry.value.inMilliseconds * _config.globalMultiplier).round(),
      );
      result[entry.key] =
          adjusted > _config.maxTimeout ? _config.maxTimeout : adjusted;
    }

    return result;
  }

  /// Reset to default configuration
  void resetToDefaults() {
    _config = _getDefaultConfiguration();
  }

  /// Validate configuration format
  bool validateConfiguration(Map<String, dynamic> config) {
    try {
      // Validate profile
      final profileName = config["timeout_profile"] as String?;
      if (profileName != null &&
          !TimeoutProfile.values.any((p) => p.name == profileName)) {
        return false;
      }

      // Validate global multiplier
      final multiplier = config["global_multiplier"];
      if (multiplier != null && multiplier is! num) {
        return false;
      }

      // Validate method timeouts format
      final methodTimeouts = config["method_timeouts"];
      if (methodTimeouts != null) {
        if (methodTimeouts is! Map) return false;

        for (final entry in methodTimeouts.entries) {
          if (entry.key is! String || entry.value is! String) return false;
          if (TimeoutConfiguration._parseDuration(entry.value as String) ==
              null) {
            return false;
          }
        }
      }

      // Validate max timeout
      final maxTimeout = config["max_timeout"] as String?;
      if (maxTimeout != null &&
          TimeoutConfiguration._parseDuration(maxTimeout) == null) {
        return false;
      }

      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  /// Get current configuration information
  Map<String, dynamic> getConfigurationInfo() {
    return {
      "profile": _config.profile.name,
      "source": _configSource ?? "default",
      "global_multiplier": _config.globalMultiplier,
      "max_timeout": "${_config.maxTimeout.inMinutes}m",
      "method_count": _config.methodTimeouts.length,
    };
  }

  @override
  void dispose() {
    unawaited(_configWatcher?.cancel());
    super.dispose();
  }
}

/// Exception thrown when configuration loading/parsing fails
class ConfigurationError extends Error {
  ConfigurationError(this.message);
  final String message;

  @override
  String toString() => "ConfigurationError: $message";
}
