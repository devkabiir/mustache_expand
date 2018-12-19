// scaffold, Copyright (C) 2018-Present Dinesh Ahuja <dev@kabiir.me>.
// See the included LICENSE file for more info.

library scaffold_test.utils;

import 'dart:io' show Platform;

import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:file/memory.dart';
import 'package:logging/logging.dart';
import 'package:scaffold/scaffold.dart';
// import 'package:travis_ci/travis_ci.dart' as travis;

const LocalFileSystem local = LocalFileSystem();

const Map<String, Object> sampleMap = {
  'name': 'my_template_map',
  'description': 'Minimum required files for a dart project',
  'author': 'Dinesh Ahuja <dev@kabiir.me>',
  'version': '0.0.1',
  'gitignore': false,
  'include': [
    {'license': '../license'},
    {'github_docs': '../github_docs'},
  ],
  'context': {
    'any_var': 'any_string_value {{projectName}}',
    'authors': [
      {'name': 'firstAuthor'},
      {'name': 'firstAuthor'},
      {'name': 'secondAuthor'},
      {'name': '{{projectName}}'},
    ],
    'any_var2': '{{any_var}}'
  },
  'pubspec': {
    'flutter': {
      'uses-material-design': true,
      'assets': ['']
    },
    'dependencies': {
      'dep_01': '0.0.1',
      'dep_02': {'path': '../'},
      'dep_03': {'git': '../'},
    },
    'dev_dependencies': {
      'dep_01': '0.0.1',
      'dep_02': {'path': '../'},
      'dep_03': {'git': '../'},
    },
  }
};

/// Logger for `scaffold_test.utils`
final Logger logger = Logger('scaffold_test.utils');

final List<LogRecord> logs = [];

final List<String> sampleYaml = [
  'description: Minimum required files for a dart project',
  'author: Dinesh Ahuja <dev@kabiir.me>',
  'version: 0.2.1',
  // 'output: base_out_dir',
  '',
  'gitignore: false',
  '',
  'pubspec:',
  '  dependencies:',
  '    none: 0.0.1',
  '  dev_dependencies:',
  '    pre_commit:',
  '      git: https://github.com/devkabiir/pre_commit/',
  '',
  'context:',
  '  authors:',
  '    - full_name: Dinesh Ahuja',
  '      display_name: devkabiir',
  '      email: dev@kabiir.me',
  '',
  '  # This is used for generating github urls',
  '  github_username: devkabiir',
  '',
  '  github_repo_url: https://github.com/{{github_username}}/{{project_name}}/',
];

void captureLogs() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen(logs.add);
}

/// Prints logged messages
/// All parameters are *ignored* on CI
///
/// [level]: Minimum level to print (defaults to `Level.All`)
///
/// [exclude*]s are injected in a
/// [RegExp]`(r'^'+HERE+'$')`, negative lookups can also be used to
/// include only certain loggers, messages or levels
///
/// e.g. `(?!pattern)`
///
/// e.g. `(?!files)`, `(?!(this)|(that))`
void logging({
  Level level = Level.ALL,
  String excludeLogger = '',
  String excludeMessage = '',
  String excludeLevel = '',
}) {
  final bool isCi = Platform.environment['CI'].toString().contains('true') ||
      Platform.environment['TRAVIS'].toString().contains('true');
  if (isCi) {
    Logger.root.level = isCi ? Level.ALL : level;
    Logger.root.onRecord.listen((rec) {
      if (!isCi) {
        if (excludeLevel.isNotEmpty &&
            RegExp('^$excludeLevel\$').hasMatch(rec.level.toString())) {
          return;
        }
        if (excludeLogger.isNotEmpty &&
            RegExp('^$excludeLogger\$').hasMatch(rec.loggerName)) {
          return;
        }
        if (excludeMessage.isNotEmpty &&
            RegExp('^$excludeMessage\$').hasMatch(rec.message)) {
          return;
        }
      }

      final loggerName = rec.loggerName.split('.');
      final rootLoggerName = loggerName.removeAt(0);
      final childrenLoggerName =
          loggerName.join('.').isEmpty ? ':' : ' ${loggerName.join('.')}:';
      final message =
          '[${rec.level}] [$rootLoggerName]$childrenLoggerName ${rec.message}';
      print(message);
    });
  }
}

void resetFs() {
  /// Set the file system to be used during testing
  fs = MemoryFileSystem(
      style:
          Platform.isWindows ? FileSystemStyle.windows : FileSystemStyle.posix);

  fs.currentDirectory = fs.directory(local.currentDirectory.absolute.path)
    ..createSync(recursive: true);

  logger.finest('fs prepared');
}

/// Returns a in-memory equivalent of given [entity]
/// Empty subdirectories are skipped
T toMemory<T extends FileSystemEntity>(T entity) {
  /// Return if already a memory FileSystemEntity
  if (entity.fileSystem is MemoryFileSystem) {
    logger.finest('$entity is already in MemoryFileSystem');
    return entity;
  }

  if (entity is File) {
    final file = getFile(entity.absolute.path);
    if (entity.existsSync()) {
      file.writeAsStringSync(entity.readAsStringSync());
    }

    logger.finest('$entity converted to $file');

    dynamic result;
    result = file;
    if (result is T) {
      return result;
    }
  }

  if (entity is Directory) {
    final directory = getDirectory(entity);

    getFiles(entity).forEach(toMemory);

    logger.finest('$entity converted to $directory');

    dynamic result;
    result = directory;
    if (result is T) {
      return result;
    }
  }

  logger.severe('$entity is not supported');
  throw Exception('Only files and directories are supported, input: $entity');
}
