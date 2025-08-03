class ErrorContext {
  final String? detectedRuntime;
  final String? targetCommand;
  final Map<String, String>? environment;
  final String? workingDirectory;
  final String? lastOutput;
  final DateTime timestamp;

  ErrorContext({
    this.detectedRuntime,
    this.targetCommand,
    this.environment,
    this.workingDirectory,
    this.lastOutput,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  ErrorContext copyWith({
    String? detectedRuntime,
    String? targetCommand,
    Map<String, String>? environment,
    String? workingDirectory,
    String? lastOutput,
    DateTime? timestamp,
  }) {
    return ErrorContext(
      detectedRuntime: detectedRuntime ?? this.detectedRuntime,
      targetCommand: targetCommand ?? this.targetCommand,
      environment: environment ?? this.environment,
      workingDirectory: workingDirectory ?? this.workingDirectory,
      lastOutput: lastOutput ?? this.lastOutput,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'detectedRuntime': detectedRuntime,
      'targetCommand': targetCommand,
      'environment': environment,
      'workingDirectory': workingDirectory,
      'lastOutput': lastOutput,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ErrorContext.fromJson(Map<String, dynamic> json) {
    return ErrorContext(
      detectedRuntime: json['detectedRuntime'] as String?,
      targetCommand: json['targetCommand'] as String?,
      environment: json['environment'] as Map<String, String>?,
      workingDirectory: json['workingDirectory'] as String?,
      lastOutput: json['lastOutput'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}