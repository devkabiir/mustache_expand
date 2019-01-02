// scaffold, Copyright (C) 2018-Present Dinesh Ahuja <dev@kabiir.me>.
// See the included LICENSE file for more info.

library scaffold_cli.exit_message;

import 'dart:io' show exitCode;

import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:scaffold/scaffold.dart';

// ignore_for_file: sort_constructors_first,
// ignore_for_file: prefer_constructors_over_static_methods

/// Logger for `scaffold_cli.exit_message`
final Logger logger = Logger('scaffold_cli.exit_message');

/// Holds an exit code in range 0..127
class ExitCode implements Comparable<dynamic> {
  /// code: 0
  static const ExitCode $0 = ExitCode._(0);

  /// code: 127
  static const ExitCode $127 = ExitCode._(127);

  /// code: 126
  static const ExitCode $126 = ExitCode._(126);

  /// code: 125
  static const ExitCode $125 = ExitCode._(125);

  /// code: 124
  static const ExitCode $124 = ExitCode._(124);

  /// code: 123
  static const ExitCode $123 = ExitCode._(123);

  /// code: 122
  static const ExitCode $122 = ExitCode._(122);

  /// code: 121
  static const ExitCode $121 = ExitCode._(121);

  /// code: 120
  static const ExitCode $120 = ExitCode._(120);

  /// Exit code

  final int value;
  const ExitCode._(this.value) : assert(value >= 0 && value <= 127);

  @override
  int get hashCode => value;

  /// Whether `this` is less than [other]
  bool operator <(dynamic other) => compareTo(other) < 0;

  /// Whether `this` is less than or equal to [other]

  bool operator <=(dynamic other) => this < other || this == other;

  @override
  bool operator ==(dynamic other) => compareTo(other) == 0;

  /// Whether `this` is greater than [other]
  bool operator >(dynamic other) => compareTo(other) > 0;

  /// Whether `this` is greater than or equal to[other]
  bool operator >=(dynamic other) => this > other || this == other;

  @override
  int compareTo(dynamic other) {
    if (other is int) {
      return value.compareTo(other);
    }

    if (other is ExitCode) {
      return value.compareTo(other.value);
    }

    if (other is ExitMessage) {
      return value.compareTo(other.code.value);
    }

    throw ArgumentError.value(other, 'other',
        'Only int, ExitCode and ExitMessage values are allowed');
  }

  @override
  String toString() => '$value';
}

/// An exit message is what any command should return from its `run` method
/// This can be utilized by tests and cli iteself for exit status of the cli
///
@immutable
class ExitMessage implements Comparable<dynamic> {
  /// code: 122, message: 'Argument(s) have invalid value(s)'
  static ExitMessage get invalidArgValues => ExitMessage(
      code: ExitCode.$122, message: 'Argument(s) have invalid value(s)');

  /// code: 124, message: 'Output is inaccissible or unspecified'
  static ExitMessage get outputInaccissible => ExitMessage(
      code: ExitCode.$124, message: 'Output is inaccissible or unspecified');

  /// code: 121, message: 'Permission denied'
  static ExitMessage get permissionDenied =>
      ExitMessage(code: ExitCode.$121, message: 'Permission denied');

  /// code: 123, message: 'Required argument(s) not provided'
  static ExitMessage get requiredArgAbsent => ExitMessage(
      code: ExitCode.$123, message: 'Required argument(s) not provided');

  /// code: 126, message: 'Template does not exist'
  static ExitMessage get templateNonExistent =>
      ExitMessage(code: ExitCode.$126, message: 'Template does not exist');

  /// Should be used only when cli args cannot be identified
  ///
  /// code: 125, message: 'Unknown additional args/flags specified'
  static ExitMessage get unknownAdditionalArgs => ExitMessage(
      code: ExitCode.$125, message: 'Unknown additional args/flags specified');

  /// Exit Code
  final ExitCode code;

  /// Optional message
  final String message;

  /// Sets [exitCode] to provided [code], [message] is logged at
  /// [failedLevel] for non-zero [code], otherwise `Level.finest` is used
  ///
  /// Note:
  /// Construction of an [ExitMessage] should be the last thing in
  /// execution stack in order to set [exitCode] as expected
  ExitMessage(
      {this.message = 'Program failed for unknown reason',
      this.code = ExitCode.$127}) {
    // ignore: unrelated_type_equality_checks
    if (code == 0) {
      logger.finest(this);
    } else {
      logger.log(failedLevel, this);
    }
    exitCode = code.value;
  }

  @override
  int get hashCode => code.hashCode;

  @override
  bool operator ==(dynamic other) => code == other;

  @override
  int compareTo(dynamic other) => code.compareTo(other);

  @override
  String toString() => '\nExit code: $code\nExit Message: $message';

  /// code: 0, message: 'Program ended successfully'
  static ExitMessage success([String message = 'Program ended successfully']) =>
      ExitMessage(code: ExitCode.$0, message: message);

  /// code: 127, message: 'Program failed for unknown reason'
  static ExitMessage unknownFailure(
          [String message = 'Program failed for unknown reason']) =>
      ExitMessage(code: ExitCode.$127, message: message);
}
