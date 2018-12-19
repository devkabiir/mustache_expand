// scaffold, Copyright (C) 2018-Present Dinesh Ahuja <dev@kabiir.me>.
// See the included LICENSE file for more info.

library scaffold_test;

import 'dart:io';

import 'package:built_value/json_object.dart';
import 'package:file/file.dart';
import 'package:logging/logging.dart';
import 'package:scaffold/scaffold.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

import 'utils.dart';

void main() {
  logging();

  group('scaffold', () {
    setUp(resetFs);

    group('getDirectory', () {
      test('returns directory with absolute path (String)', () {
        expect(getDirectory('templates/base').path,
            cleanPath(fs.directory('templates/base').absolute.path));
      });

      test('returns directory with absolute path (Directory)', () {
        expect(getDirectory(local.directory('templates/base')).path,
            cleanPath(fs.directory('templates/base').absolute.path));
      });
    });

    group('context', () {
      test('+ operator does not override instance data', () {
        Context someContext = Context();
        final testMap = {'someKey': 'some value'};
        final afterAddition = someContext + testMap;

        expect(afterAddition.containsKey('someKey'), isTrue);
        expect(someContext.containsKey('someKey'), isFalse);

        someContext += testMap;

        expect(someContext.containsKey('someKey'), isTrue);
      });
    });

    group('utils', () {
      group('toMemory', () {
        test('converts local file to memory file', () {
          final localFile = local.file(cleanPath('test/utils.dart'));
          final memoryFile = toMemory(localFile);

          testFileMatches(memoryFile, localFile);
        });

        test('converts local directory to memory directory recursively', () {
          final localDirectory = local.directory(cleanPath('templates'));
          final memoryDirectory = toMemory(localDirectory);

          final localFiles = getFiles(localDirectory);

          final memoryFiles = getFiles(memoryDirectory);

          Map.fromIterables(localFiles, memoryFiles).forEach(testFileMatches);
        });
      });
    });

    group('renderString', () {
      /// This is only required because [Context.defaults] depends on it
      /// Real scenarios might not need it
      setUp(() => projectDir = getDirectory(''));

      test('can render mustache strings with provided context', () {
        expect(
            renderString(
              '{{var_name}}',
              <String, String>{'var_name': 'dart_project'},
            ),
            'dart_project');
      });

      test('can render mustache strings with nested variables in context', () {
        expect(
            renderString('{{some_var}}', <String, String>{
              'var_name': 'dart_project',
              'my_var': 'My project: {{var_name}}',
              'some_var': '{{my_var}}',
            }),
            'My project: dart_project');

        expect(
            renderString(
              '{{github_repo_url}}',
              <String, String>{
                'var_name': 'my_app',
                'github_username': 'devkabiir',
                'github_repo_url':
                    'https://github.com/{{github_username}}/{{var_name}}/'
              },
            ),
            'https://github.com/devkabiir/my_app/');
      });

      test('can render nested variables after inline delimiter change', () {
        expect(
            renderString('''
          * {{var_name}}
          {{=<% %>=}}
          * <% some_var %>
          <%={{ }}=%>
          * {{ my_var }}
          ''', <String, String>{
              'var_name': 'dart_project',
              'my_var': 'My project: {{var_name}}',
              'some_var': '{{my_var}}',
            }),
            '''
          * dart_project
          * My project: dart_project
          * My project: dart_project
          ''');

        expect(
            renderString('''
          * {{var_name}}
          {{=__ DD=}}
          * __ some_var DD
          __={{ }}=DD
          * {{ my_var }}
          ''', <String, String>{
              'var_name': 'dart_project',
              'my_var': 'My project: {{var_name}}',
              'some_var': '{{my_var}}',
            }),
            '''
          * dart_project
          * My project: dart_project
          * My project: dart_project
          ''');
      });

      test('throws for non-lenient variables in string', () {
        expect(() => renderString('{{some var}}'),
            throwsA(const TypeMatcher<TemplateException>()));
      });

      test('throws for non-lenient nested variables in context', () {
        expect(
            () => renderString('{{some_var}}', <String, String>{
                  'Project Name': 'Dart Project',
                  'my_var': 'My project: {{Project Name}}',
                  'some_var': '{{my_var}}',
                }),
            throwsA(const TypeMatcher<TemplateException>()));
      });
    });

    group('recase', () {
      test('returns all available cases', () {
        final expected = <String, String>{
          'projectName': 'myProject',
          'PROJECT_NAME': 'MY_PROJECT',
          'project.name': 'my.project',
          'Project-Name': 'My-Project',
          'project-name': 'my-project',
          'ProjectName': 'MyProject',
          'project/name': 'my/project',
          'Project name': 'My project',
          'project_name': 'my_project',
          'Project Name': 'My Project',
        };
        // final actual = recase('project_name', 'my_project');

        expect(Context() * {'project_name': 'my_project'}, expected);
      });

      test('does not override existing cases', () {
        expect(Context() * {'key': 'value'}, <String, String>{
          'key': 'value',
          'KEY': 'VALUE',
          'Key': 'Value',
        });
      });
    });

    group('toPrimitive', () {
      test('converts YamlScalar to dart primitive', () {
        final boolean = YamlScalar.wrap(true);
        final string = YamlScalar.wrap('true');
        final number = YamlScalar.wrap(2);

        expect(toPrimitive<bool>(boolean), isTrue);
        expect(toPrimitive<String>(string), 'true');
        expect(toPrimitive<num>(number), 2);
      });

      test('converts YamlList to List', () {
        final yamlListSimple = YamlList.wrap(<String>['dartList']);
        final yamlListNested = <YamlList>[
          YamlList.wrap(<String>['dartList'])
        ];

        expect(toPrimitive<List>(yamlListSimple), ['dartList']);
        expect(toPrimitive<List>(yamlListNested), [
          ['dartList']
        ]);
      });

      test('converts YamlMap to Map', () {
        final yamlMapSimple = YamlMap.wrap(<String, String>{'key': 'value'});
        final yamlMapNested = <String, dynamic>{
          'superKey': YamlMap.wrap(<String, String>{'key': 'value'})
        };

        expect(toPrimitive<Map>(yamlMapSimple), {'key': 'value'});
        expect(toPrimitive<Map>(yamlMapNested), {
          'superKey': {'key': 'value'}
        });
      });

      test('converts JsonObject to dart primitive', () {
        final boolean = JsonObject(true);
        final string = JsonObject('true');
        final number = JsonObject(2);

        expect(toPrimitive<bool>(boolean), isTrue);
        expect(toPrimitive<String>(string), 'true');
        expect(toPrimitive<num>(number), 2);
      });

      test('converts ListJsonObject to List', () {
        final yamlListSimple = ListJsonObject(<String>['dartList']);
        final yamlListNested = <ListJsonObject>[
          ListJsonObject(<String>['dartList'])
        ];

        expect(toPrimitive<List>(yamlListSimple), ['dartList']);
        expect(toPrimitive<List>(yamlListNested), [
          ['dartList']
        ]);
      });

      test('converts MapJsonObject to Map', () {
        final yamlMapSimple = MapJsonObject(<String, String>{'key': 'value'});
        final yamlMapNested = <String, dynamic>{
          'superKey': MapJsonObject(<String, String>{'key': 'value'})
        };

        expect(toPrimitive<Map>(yamlMapSimple), {'key': 'value'});
        expect(toPrimitive<Map>(yamlMapNested), {
          'superKey': {'key': 'value'}
        });
      });
    });
  });
}

/// Logger for `scaffold_test`
final Logger logger = Logger('scaffold_test.core');

void testFileMatches(File file01, File file02) {
  expect(
    file01.readAsStringSync(),
    file02.readAsStringSync(),
    reason: '${file01.path} differs in content with ${file02.path}',
  );

  expect(
    file01.absolute.path,
    file02.absolute.path,
    reason: "paths don't match",
  );
}
