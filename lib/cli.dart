// scaffold, Copyright (C) 2018-Present Dinesh Ahuja <dev@kabiir.me>.
// See the included LICENSE file for more info.

library scaffold_cli;

import 'dart:io' show stderr, stdout;

import 'package:args/command_runner.dart' as cr;
import 'package:file/local.dart';
import 'package:io/ansi.dart' as ansi;
import 'package:logging/logging.dart';
import 'package:scaffold/src/exit_codes.dart';

import 'scaffold.dart';
import 'src/commands/create.dart';

/// Logger for `scaffold_cli`
final Logger logger = Logger('scaffold_cli');

/// Start the command runner with [args] to parse
Future<void> run([List<String> args]) async {
  if (!args.any((a) => a.contains('--suppress'))) {
    stdout.write('[»] Please wait...');
  }

  final commandRunner = cr.CommandRunner<ExitMessage>(
    'scaffold',
    'CLI app for assisting dart developers',
  )..addCommand(CreateCommand());

  final exitMessage = await commandRunner.run(args);
  if (args.any((a) => a.contains('--exit-message'))) {
    if (exitMessage.code == ExitCode.$0) {
      stdout.writeln(exitMessage.message);
    } else {
      stderr.writeln(exitMessage.message);
    }
  }
}

/// A base class defining shared behaviour among commands
abstract class ScaffoldCommand extends cr.Command<ExitMessage> {
  /// Adds few special args
  ScaffoldCommand() {
    argParser.addFlag(
      'verbose',
      defaultsTo: false,
      help: 'Show verbose output',
      hide: true,
    );

    argParser.addFlag(
      'dry',
      defaultsTo: false,
      help: 'Do a dry run (no filesystem modifications)',
      hide: true,
    );

    argParser.addFlag(
      'trace',
      defaultsTo: false,
      help: 'Collects and prints stacktrace for errorous log levels',
      hide: true,
    );

    argParser.addFlag(
      'suppress',
      defaultsTo: false,
      help: 'Does not output anything to stdout/stderr',
      hide: true,
    );

    argParser.addFlag(
      'exit-message',
      defaultsTo: false,
      help: 'Output the exit message to stdout/stderr (ignores --suppress)',
      hide: true,
    );

    argParser.addFlag(
      'decorations',
      defaultsTo: true,
      help: 'Apply asci decorations to stdout/stderr',
      hide: true,
    );
  }
  @override
  String get description => 'A scaffold command';

  /// Logger for `scaffold_cli.create`
  Logger get logger;

  @override
  String get name => 'scaffold';

  /// Returns formatted and [decorated] version of [rec]
  String formatLogRecord(LogRecord rec,
      {bool printStackTrace = false,
      bool isVerbose = false,
      bool decorated = false}) {
    final includeStackTrace =
        printStackTrace && rec.level >= recordStackTraceAtLevel;

    final loggerName = '[${rec.loggerName.split('.').join('] [')}]';

    String level = '[${rec.level}]';

    if (decorated) {
      switch (rec.level.toString()) {
        case 'SUCCESS':
          level = ansi.wrapWith(level, [
            ansi.lightGreen,
          ]);
          level = '✔ $level';
          break;
        case 'INFO':
          level = ansi.wrapWith(level, [
            ansi.lightBlue,
          ]);
          level = 'ℹ $level';
          break;
        case 'FINE':
        case 'FINER':
        case 'FINEST':
          level = ansi.wrapWith(level, [
            ansi.lightCyan,
          ]);
          level = '→ $level';
          break;
        case 'WARNING':
          level = ansi.wrapWith(level, [
            ansi.lightYellow,
          ]);
          level = '⚠ $level';
          break;
        case 'SEVERE':
        case 'SHOUT':
          level = ansi.wrapWith(level, [
            ansi.lightRed,
          ]);
          level = '❕❕ $level';
          break;
        case 'FAILED':
          level = ansi.wrapWith(level, [
            ansi.red,
          ]);
          level = '✖ $level';
          break;
        default:
          level = ansi.lightGray.wrap(level);
      }
    }

    final message = isVerbose
        ? [
            '[${rec.time}] $level $loggerName ${rec.message}',
            includeStackTrace ? 'Stacktrace:\n${rec.stackTrace}' : '',
          ].join('\n')
        : '$level ${rec.message}';

    return message;
  }

  /// Listens for [LogRecord]s
  ///
  /// Sets up [fs]
  ///
  /// Should be run inside `run` method
  void setup() {
    final bool isVerbose = argResults.wasParsed('verbose');
    final bool isDryMode = argResults.wasParsed('dry');
    final bool shouldSuppressOutput = argResults.wasParsed('suppress');
    final bool printStackTrace = argResults.wasParsed('trace');
    final bool applyDecorations = argResults['decorations'];

    /// Returns to the start of console line
    /// Which helps clear/reset it
    stdout.write('\r');

    Logger.root.level = successLevel;

    if (printStackTrace && isVerbose) {
      recordStackTraceAtLevel = Level.WARNING;
    }

    fs = isDryMode ? fs : const LocalFileSystem();

    Logger('scaffold').onRecord.listen((rec) {
      if (!isVerbose &&
          (rec.level >= Level.FINEST && rec.level <= Level.FINE)) {
        return;
      }

      final message = formatLogRecord(
        rec,
        isVerbose: isVerbose,
        printStackTrace: printStackTrace,
        decorated: applyDecorations,
      );

      if (!shouldSuppressOutput) {
        if (rec.level >= Level.WARNING) {
          stderr.writeln(message);
        } else {
          stdout.writeln(message);
        }
      }
    });
  }
}

///
class UsageException extends cr.UsageException {
  ///
  UsageException(String message, ScaffoldCommand command)
      : super(message, command.usage) {
    command.logger.finest('Provided args:\n'
        '${command.argResults.arguments.join('\n')}');
  }
}
