// scaffold, Copyright (C) 2018-Present Dinesh Ahuja <dev@kabiir.me>.
// See the included LICENSE file for more info.

library scaffold_cli.create;

import 'package:logging/logging.dart';

import '../../cli.dart';
import '../../scaffold.dart';
import '../exit_codes.dart';

/// Create command for the scaffold
/// Usage: `scaffold create my_project --template=<comma-seperated-templates>`
class CreateCommand extends ScaffoldCommand {
  /// Usage: `scaffold create my_project --template=<comma-seperated-templates>`
  CreateCommand() : super() {
    argParser.addOption(
      'template',
      abbr: 't',
      help: 'The path to template directory '
          '(should have a ${Template.configFileName})',
      valueHelp: 'path/to/template',
    );

    argParser.addFlag(
      'overwrite',
      abbr: 'o',
      defaultsTo: false,
      help: 'Overwrite existing files',
    );
  }

  @override
  String get description =>
      'Create a new dart project using specified template';

  @override
  String get invocation =>
      '${runner.executableName} $name <output-directory> [arguments]';

  /// Logger for `scaffold_cli.create`
  @override
  Logger get logger => Logger('scaffold_cli.create');

  @override
  String get name => 'create';

  @override
  ExitMessage run() {
    super.setup();
    final String templateDirs = argResults['template'];
    final bool overwrite = argResults['overwrite'];
    logger.fine('cwd: ${fs.currentDirectory.path}');

    if (argResults.rest.isEmpty) {
      logger.severe(UsageException('No output directory specified', this));

      return ExitMessage.outputInaccissible;
    }

    if (argResults.rest.length > 1) {
      var message = '(Possibly) Multiple output directories specified.';

      for (var arg in argResults.rest) {
        if (arg.startsWith('-')) {
          message += '\nTry moving $arg to be immediately following $name';
          break;
        }
      }
      logger.severe(UsageException(message, this));

      return ExitMessage.unknownAdditionalArgs;
    }

    if (!argResults.wasParsed('template') || templateDirs.isEmpty) {
      logger.severe(UsageException('No template specified', this));

      return ExitMessage.templateNonExistent;
    }

    // TODO(devkabiir): check whether -t arg is a template name or directory, https://www.github.com/devkabiir/scaffold/issues/9
    /// Validate template directory
    final td =
        fs.directory(cleanPath(fs.directory(templateDirs).absolute.path));
    logger.info('Template directory: ${td.path}');

    if (!td.existsSync()) {
      logger.severe(UsageException(
              "Template directory: $templateDirs doesn't exist", this)
          .toString());

      return ExitMessage.templateNonExistent;
    }

    /// Set [projectDir] so a [Template] can reference it
    projectDir = getDirectory(argResults.rest.first);

    logger.info('Output directory: ${projectDir.path}');

    try {
      Template.fromDirectory(getDirectory(td)).render(overwrite: overwrite);
    } on TemplateException catch (e) {
      logger.severe(e.toString());

      return ExitMessage.unknownFailure(e.toString());
    }

    logger.log(successLevel, 'Template rendered successfully');

    return ExitMessage.success(projectDir.path);
  }
}
