// scaffold, Copyright (C) 2018-Present Dinesh Ahuja <dev@kabiir.me>.
// See the included LICENSE file for more info.

library scaffold_test.template;

import 'dart:io' show Platform;

import 'package:file/file.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;
import 'package:scaffold/scaffold.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  logging(
    excludeLogger: '(?!template)',
    excludeLevel: Level.FINEST.toString(),
  );

  group('Template', () {
    setUp(() {
      /// Reset [fs]
      resetFs();

      /// This populates the [fs]
      toMemory(local.directory(cleanPath('templates')));
      projectDir = getDirectory('my_app');
      logger.finer('fs and context reset');
    });

    test('can instantiate from ${Template.configFileName}', () {
      final sampleYamlWithInclude = sampleYaml.toList()
        ..addAll([
          'name: sampleYaml',
          'include:',
          '  - license: ../license',
          '  - github_docs: ../github_docs',
        ]);

      /// This is a in-memory template
      final smapleTemplateConfig =
          getDirectory('templates/sampleTemplateWithInclude')
              .childFile(Template.configFileName)
                ..createSync(recursive: true)
                ..writeAsStringSync(sampleYamlWithInclude.join('\n'));
      final template = Template.fromDirectory(smapleTemplateConfig.parent);

      expect(template.name, 'sampleYaml');

      expect(toPrimitive<List>(template.context['authors']), [
        {
          'email': 'dev@kabiir.me',
          'full_name': 'Dinesh Ahuja',
          'display_name': 'devkabiir'
        }
      ]);

      final includes = template.include.map<String>((t) => t.name).toList();
      expect(includes, ['license', 'github_docs']);

      expect(
          toPrimitive<Map<String, dynamic>>(
              template.pubspec.dependencies.asMap()),
          {'none': '0.0.1'});
    });

    test('can instantiate from a map', () {
      /// This test might not be necessary
      final tm = serializers
          .deserializeWith(Template.serializer, sampleMap)
          .rebuild((b) => b
            ..config = getFile(getDirectory('templates/sampleMap')
                .childFile(Template.configFileName)));

      expect((toPrimitive<List>(tm.context['authors'])).first['name'],
          'firstAuthor');

      expect(toPrimitive<Map>(tm.pubspec.devDependencies.asMap()), {
        'dep_01': '0.0.1',
        'dep_02': {'path': '../'},
        'dep_03': {'git': '../'}
      });

      expect(
          renderString(
              [
                '{{projectName}}',
                '  {{#authors}}',
                '  - {{name}}',
                '  {{/authors}}',
              ].join('\n'),
              tm.context),
          [
            'myApp',
            '  - firstAuthor',
            '  - firstAuthor',
            '  - secondAuthor',
            '  - myApp',
            ''
          ].join('\n'));
    }, skip: true);

    test('can update fields using builder pattern', () {
      final tm = serializers.deserializeWith(Template.serializer, sampleMap);

      expect(tm.pubspec.flutter.asMap()['uses-material-design'].asBool,
          equals(true));

      // final updatedFlutter = tm.pubspec.flutter.rebuild((b) => b
      //   ..addAll({
      //     'uses-material-design': JsonObject(false),
      //     'arbitrary_key': JsonObject('arbitrary_value')
      //   }));
      // final newTm =
      //     tm.rebuild((b) => b.pubspec..flutter = updatedFlutter.toBuilder());

      // expect(newTm.pubspec.flutter.asMap()['uses-material-design'].asBool,
      //     equals(false));
      // expect(newTm.pubspec.flutter.asMap()['arbitrary_key'].asString,
      //     equals('arbitrary_value'));
    }, skip: true);

    test('can render template files', () {
      /// may not need this test
      final templateDir = getDirectory('templates/sampleTemplateRenderTest');

      templateDir.childFile(Template.configFileName)
        ..createSync(recursive: true)
        ..writeAsStringSync((sampleYaml.toList()
              ..add('name: sampleTemplateRenderTest'))
            .join('\n'));

      /// Prefixing copy only files with `copy_only` helps in testing
      /// this is not required for actual usage
      final templateFiles = [
        'file01.ext',
        'lib/should_render.ext',
        'lib/test/should_render.ext',
        'test/sub_dir.copy/copy_only_should_not_render.ext',
        'test.copy/must_render.ext.tmpl',
        'test.copy/copy_only_file01.ext',
      ].map((f) => getFile(templateDir.childFile(f).path));

      final mustacheTemplate = [
        '{{projectName}} @ {{github_repo_url}}',
        '  {{#authors}}',
        '  - {{full_name}}',
        '  {{/authors}}',
        'Scaffolded using,',
        'Template: {{template_name}} - v{{template_version}}',
        'Author: {{template_author}}',
      ].join('\n');

      /// Prepare template files
      for (var file in templateFiles) {
        file.writeAsStringSync(
          mustacheTemplate,
        );
      }

      /// Render
      final template = Template.fromDirectory(templateDir);
      expect(
        template.render,
        isNot(throwsA(equals(const TypeMatcher<dynamic>()))),
        reason: 'Should not throw anything',
      );

      /// The template also renders fils for all of it's includes
      /// we don't care about those files hence this workaround
      final outputFiles = templateFiles

          /// Clear out extensions
          .map((f) => f.path.replaceAll(RegExp(r'(\.copy)|(\.tmpl)'), ''))

          /// Make the path absolute to [projectDir]
          .map((f) =>
              f.replaceAll('templates${Platform.pathSeparator}', '').replaceAll(
                  RegExp(
                    template.directory.basename,

                    /// Required for it to work cross-platform
                    caseSensitive: false,
                  ),
                  'my_app'))
          .map(getFile);

      expect(
          outputFiles.map((f) => f.path).toList()
            ..sort((a, b) => a.compareTo(b)),
          template.files
              .map((f) => f.destination.path)

              /// `pubspec.yaml` is auto-generated
              .where((f) => !f.contains('pubspec.yaml'))
              .toList()
                ..sort((a, b) => a.compareTo(b)),
          reason: 'workaround does not work');

      final renderedFiles =
          outputFiles.where((f) => !f.basename.contains('copy_only')).toList();

      final copiedFiles =
          outputFiles.where((f) => f.basename.contains('copy_only')).toList();

      /// Check file names
      expect(
          getFiles(template.output)
              .any((f) => f.path.contains(RegExp(r'(\.copy)|(\.tmpl)'))),
          isFalse);

      for (var file in renderedFiles) {
        expect(
          file.readAsStringSync(),
          [
            'myApp @ https://github.com/devkabiir/my_app/',
            '  - Dinesh Ahuja',
            'Scaffolded using,',
            'Template: sampleTemplateRenderTest - v0.2.1',
            'Author: Dinesh Ahuja <dev@kabiir.me>',
          ].join('\n'),
          reason: 'file did not render ${file.path}',
        );
      }

      for (var file in copiedFiles) {
        expect(file.readAsStringSync(), mustacheTemplate);
      }

      expect(
        template.output.childFile('pubspec.yaml').existsSync(),
        isTrue,
        reason: 'Pubspec yaml should always exist',
      );

      expect(
        template.output
            .childFile('pubspec.yaml')
            .readAsStringSync()
            .split('\n'),
        [
          'name: "my_app"',
          'version: "0.0.0"',
          'description: "A new dart project"',
          'author: "Dinesh Ahuja <dev@kabiir.me>"',
          'homepage: "https://link/to/homepage"',
          'dependencies: ',
          '  none: "0.0.1"',
          '',
          'dev_dependencies: ',
          '  pre_commit: ',
          '    git: "https://github.com/devkabiir/pre_commit/"',
          '',
          'environment: ',
          '  sdk: ">=2.0.0 <3.0.0"',
          '',
          '',
        ],
        reason: 'pubspec.yaml not rendered properly',
      );
    });

    group('[built-in]', () {
      final List<Directory> localTemplates = local
          .directory(cleanPath('templates'))
          .listSync()
          .whereType<Directory>()
          .toList();

      for (var templateDir in localTemplates) {
        test('${templateDir.basename} is valid', () {
          logger.fine('Trying ${templateDir.path}');

          final template =
              Template.fromDirectory(getDirectory(templateDir.path));

          expect(
            template.render,
            isNot(throwsA(equals(const TypeMatcher<dynamic>()))),
            reason: 'Built-in template should not throw anything',
          );

          for (var file in template.files) {
            /// Template is rendered inside [projectDir]
            /// it could be rendered inside a sub-directory too
            expect(
              p.isWithin(projectDir.path, file.destination.path),
              isTrue,
              reason: [
                '${file.source.path} should be rendered inside',
                '${projectDir.path}, actual path was',
                '${file.destination.path}',
              ].join('\n'),
            );

            if (!file.copyOnly || file.forceRender) {
              /// This should be rendered
              final destRendered = file.destination.readAsStringSync();
              final sourceRendered =
                  renderString(file.source.readAsStringSync(), file.context);

              final hasCopy = file.source.path.contains('.copy');
              final hasTmpl = file.source.path.contains('.tmpl');
              expect(
                hasCopy && hasTmpl,
                hasCopy,
                reason: 'path should have .tmpl if it has .copy',
              );

              expect(destRendered, sourceRendered,
                  reason: [
                    '${file.source.path} did not render properly ',
                    'File context: ${file.context}',
                    'Default context: ${Context.defaults}'
                  ].join('\n'));
            } else {
              /// This is a copy only template, .tmpl should be rendered
              expect(
                file.source.path.contains('.tmpl'),
                isFalse,
                reason: 'should not have .tmpl in its path',
              );

              expect(
                file.destination.readAsStringSync(),
                file.source.readAsStringSync(),
                reason: 'did not copy properly',
              );
            }

            /// Should not contain either `.copy` or `.tmpl`
            /// in its path
            expect(
              file.destination.path.contains(RegExp(r'(\.copy)|(\.tmpl)')),
              isFalse,
              reason: 'path should not have .copy/.tmpl ',
            );

            /// Should not contain either `{{` or `}}`
            /// in its path
            expect(
              file.destination.path.contains(RegExp(r'({{)|(}})')),
              isFalse,
              reason: 'path should be rendered',
            );
          }
        });
      }
    });

    group('[TemplateRef]', () {
      test('returns valid template from absolute path', () {
        final base = getDirectory('templates/base');
        expect(TemplateRef({'base': base.absolute.path}).template.name,
            Template.fromDirectory(base).name);
      });

      test('returns valid template from relative path to parent template', () {
        expect(
            TemplateRef({'vscode_snips': '../vscode_snips'},
                    Template.fromDirectory(getDirectory('templates/base')))
                .template
                .name,
            Template.fromDirectory(getDirectory('templates/vscode_snips'))
                .name);
      });
    });
  });
}

/// Logger for `scaffold_test.template`
final Logger logger = Logger('scaffold_test.template');
