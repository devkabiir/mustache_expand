// scaffold, Copyright (C) 2018-Present Dinesh Ahuja <dev@kabiir.me>.
// See the included LICENSE file for more info.

library scaffold_test.integration.cli;

import 'package:args/command_runner.dart';
import 'package:logging/logging.dart';
import 'package:scaffold/scaffold.dart';
import 'package:scaffold/src/commands/create.dart';
import 'package:scaffold/src/exit_codes.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  group('cli', () {
    CommandRunner<ExitMessage> commandRunner;

    const testArgs = [
      '--verbose',
      '--dry',
      '--trace',
      '--suppress',
    ];

    setUpAll(captureLogs);

    setUp(() {
      logs.clear();

      resetFs();
      toMemory(local.directory(cleanPath('templates')));

      commandRunner = CommandRunner<ExitMessage>(
        'scaffold',
        'CLI app for assisting dart developers',
      );
    });

    tearDown(() {
      expect(
        logs.fold<int>(
            0, (count, rec) => rec.level == successLevel ? count + 1 : count),
        lessThanOrEqualTo(1),
        reason: 'More than 1 success message(s)',
      );

      expect(
        logs.fold<int>(
            0, (count, rec) => rec.level == failedLevel ? count + 1 : count),
        lessThanOrEqualTo(1),
        reason: 'More than 1 failed message(s)',
      );

      expect(
        logs.fold<int>(
            0, (count, rec) => rec.object is ExitMessage ? count + 1 : count),
        equals(1),
        reason: 'Number of ExitMessage(s) is not 1',
      );

      expect(
        logs.last.object,
        const TypeMatcher<ExitMessage>(),
        reason: 'Last message is not an ExitMessage',
      );
    });

    group('create', () {
      setUp(() {
        commandRunner.addCommand(CreateCommand());
      });

      test('renders template successfully', () async {
        final args = [
          'create',
          'my_app',
          '-t./templates/dart_package',
        ]..addAll(testArgs);

        await commandRunner.run(args);

        expect(
          logs[logs.length - 2].level,
          equals(successLevel),
          reason: 'Built-in template did not render successfully',
        );

        expect(
          0,
          equals(logs.last.object),
          reason: 'Built-in template exit code is not 0',
        );

        for (var i = 0; i < logs.length; i++) {
          expect(
            logs[i].level,
            lessThan(Level.WARNING),
            reason: 'There are unexpected messages in the logs',
          );
        }
      });
    });
  });
}

/// Logger for `scaffold_test.integration.cli`
final Logger logger = Logger('scaffold_test.integration.cli');
