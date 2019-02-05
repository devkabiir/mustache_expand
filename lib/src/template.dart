// scaffold, Copyright (C) 2018-Present Dinesh Ahuja <dev@kabiir.me>.
// See the included LICENSE file for more info.

library scaffold.template;

import 'dart:collection';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:io/ansi.dart' as ansi;
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';
import 'package:yamlicious/yamlicious.dart' show toYamlString;

import '../scaffold.dart';

part 'template.g.dart';

/// Logger for `scaffold.template`
final Logger logger = Logger('scaffold.template');

///
@SerializersFor([Template, Pubspec])
final Serializers serializers = (_$serializers.toBuilder()
      ..addPlugin(StandardJsonPlugin())
      ..add(Pubspec.serializer)
      ..addBuilderFactory(
          const FullType(BuiltMap, [FullType(String), FullType(String)]),
          () => MapBuilder<String, String>())
      ..add(ContextSerializer()))
    .build();

// ignore_for_file: sort_constructors_first

/// Returns all files from [directory], while skipping [Template.configFileName]
/// and `pubspec.yaml`
List<File> getTemplates(Directory directory) => getFiles(directory)
  ..removeWhere((File t) =>
      t.basename == Template.configFileName || t.basename == 'pubspec.yaml');

/// Serializes `context` field of `Template.configFileName` to [Context]
class ContextSerializer implements StructuredSerializer<Context> {
  @override
  Iterable<Type> get types => BuiltList(<Type>[Context]);

  @override
  String get wireName => 'map';

  @override
  Context deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    if (serialized.length % 2 == 1) {
      throw ArgumentError('serialized object has odd length :$serialized');
    }

    final map = <String, JsonObject>{};

    for (int i = 0; i != serialized.length; i += 2) {
      final String key = serializers.deserialize(serialized.elementAt(i),
          specifiedType: const FullType(String));
      final JsonObject value = serializers.deserialize(
          serialized.elementAt(i + 1),
          specifiedType: const FullType(JsonObject));
      map[key] = value;
    }

    return Context(toPrimitive<Map<String, dynamic>>(map));
  }

  @alwaysThrows
  @override
  Iterable serialize(Serializers serializers, Context object,
          {FullType specifiedType = FullType.unspecified}) =>
      throw Exception('Not Implemented');
}

/// Model calss for pubspec specific config provided via
/// [Template.configFileName]
abstract class Pubspec implements Built<Pubspec, PubspecBuilder> {
  /// Used for serializing and deserializing data
  static Serializer<Pubspec> get serializer => _$pubspecSerializer;

  /// Instantiate a [Pubspec] using builder pattern
  factory Pubspec([void updates(PubspecBuilder b)]) = _$Pubspec;

  Pubspec._();

  /// author of this project
  @nullable
  String get author;

  /// authors of this project
  @nullable
  BuiltList<String> get authors;

  /// dependencies for this project
  @nullable
  BuiltMap<String, JsonObject> get dependencies;

  /// dependency_overrides for this project
  @BuiltValueField(wireName: 'dependency_overrides')
  @nullable
  BuiltMap<String, JsonObject> get dependencyOverrides;

  /// description of this project
  @nullable
  String get description;

  /// dev_dependencies for this project
  @BuiltValueField(wireName: 'dev_dependencies')
  @nullable
  BuiltMap<String, JsonObject> get devDependencies;

  /// documentation of this project
  @nullable
  String get documentation;

  /// environment of this project
  @nullable
  BuiltMap<String, String> get environment;

  /// executables of this project
  @nullable
  BuiltMap<String, String> get executables;

  /// Flutter specific config
  @nullable
  BuiltMap<String, JsonObject> get flutter;

  /// homepage of this project
  @nullable
  String get homepage;

  /// Parent template of this pubspec
  @nullable
  Template get parent;

  /// publish_to of this project
  @nullable
  @BuiltValueField(wireName: 'publish_to')
  String get publishTo;

  /// version for this project
  @nullable
  String get version;

  /// Create a `pubspec.yaml` [TemplateFile] in memory
  /// so it can be rendered with other files
  TemplateFile generateTemplateFile() {
    if (parent.parent != null) {
      logger.warning(TemplateException(
        'Pubspec can only be generated for parent templates',
        templateName: parent.name,
        templateLocation: parent.directory.path,
      ));
    }

    final content = _toMap() ?? <String, dynamic>{};
    const newLine = '\n';

    final StringSink sink = StringBuffer()
      ..writeAll(<String>[
        toYamlString(<String, dynamic>{'name': content['name']}),
        toYamlString(<String, dynamic>{'version': content['version']}),
        toYamlString(<String, dynamic>{'description': content['description']}),
        toYamlString(content.containsKey('authors')
            ? <String, dynamic>{'authors': content['authors']}
            : <String, dynamic>{'author': content['author']}),
        toYamlString(<String, dynamic>{'homepage': content['homepage']}),
        content.containsKey('documentation')
            ? toYamlString(<String, dynamic>{
                  'documentation': content['documentation']
                }) +
                newLine
            : '',
        content.containsKey('dependencies')
            ? toYamlString(<String, dynamic>{
                  'dependencies': content['dependencies']
                }) +
                newLine
            : '',
        content.containsKey('dev_dependencies')
            ? toYamlString(<String, dynamic>{
                  'dev_dependencies': content['dev_dependencies']
                }) +
                newLine
            : '',
        content.containsKey('dependency_overrides')
            ? toYamlString(<String, dynamic>{
                  'dependency_overrides': content['dependency_overrides']
                }) +
                newLine
            : '',
        content.containsKey('environment')
            ? toYamlString(
                <String, dynamic>{'environment': content['environment']})
            : toYamlString(<String, dynamic>{
                'environment': {'sdk': '>=2.0.0 <3.0.0'}
              }),
        newLine,
        content.containsKey('executables')
            ? toYamlString(
                    <String, dynamic>{'executables': content['executables']}) +
                newLine
            : '',
        content.containsKey('publish_to')
            ? toYamlString(
                    <String, dynamic>{'publish_to': content['publish_to']}) +
                newLine
            : '',
        content.containsKey('flutter')
            ? toYamlString(<String, dynamic>{'flutter': content['flutter']}) +
                newLine
            : '',
      ]);

    /// Creating a in-memory template file so that local filesystem stays clean
    final fs = MemoryFileSystem();
    final pubspecFile = fs.file(p.join(parent.directory.path, 'pubspec.yaml'))
      ..createSync(recursive: true);

    if (content.isNotEmpty) {
      pubspecFile.writeAsStringSync(sink.toString());
    }

    return TemplateFile(pubspecFile, parent);
  }

  /// Generated pubspec as a map
  @memoized
  Map<String, dynamic> _toMap() {
    final thisPubspec = <String, dynamic>{};

    final includePubspecs =
        parent.include.map((t) => t.pubspec?._toMap() ?? <String, dynamic>{});

    thisPubspec['name'] = Context.defaults['project_name'];
    thisPubspec['description'] = description ??
        parent.context['description'] ??
        Context.defaults['description'];
    thisPubspec['version'] = version ?? '0.0.0';

    thisPubspec['homepage'] =
        homepage ?? parent.homepage ?? 'https://link/to/homepage';
    if (publishTo != null) {
      thisPubspec['publish_to'] = publishTo;
    }
    if (documentation != null) {
      thisPubspec['documentation'] = documentation;
    }

    if (authors != null) {
      thisPubspec['authors'] = toPrimitive<Map>(authors.asList());
    } else {
      thisPubspec['author'] =
          author ?? parent.author ?? 'Your name <your@email.com>';
    }

    if (dependencies != null) {
      thisPubspec['dependencies'] = toPrimitive<Map>(dependencies.asMap());
    }
    if (devDependencies != null) {
      thisPubspec['dev_dependencies'] =
          toPrimitive<Map>(devDependencies.asMap());
    }
    if (dependencyOverrides != null) {
      thisPubspec['dependency_overrides'] =
          toPrimitive<Map>(dependencyOverrides.asMap());
    }
    if (flutter != null) {
      thisPubspec['flutter'] = toPrimitive<Map>(flutter.asMap());
    }
    if (environment != null) {
      thisPubspec['environment'] = toPrimitive<Map>(environment.asMap());
    }
    if (executables != null) {
      thisPubspec['executables'] = toPrimitive<Map>(executables.asMap());
    }

    final pubspec = <String, dynamic>{};

    includePubspecs.toList()
      ..add(thisPubspec)
      ..forEach((p) {
        for (var pKey in p.keys) {
          final dynamic pValue = p[pKey];
          if (isPrimitive(pValue)) {
            pubspec[pKey] = pValue;
            continue;
          }

          final dynamic oldValue = pubspec[pKey];
          if (oldValue == null) {
            pubspec[pKey] = pValue;
            continue;
          }

          if (pValue is Map && oldValue is Map) {
            pubspec[pKey] = oldValue..addAll(pValue);
            continue;
          }

          if (pValue is List && oldValue is List) {
            pubspec[pKey] = oldValue..addAll(pValue);
            continue;
          }
        }
      });

    return pubspec;
  }
}

/// Model class for a [Template.configFileName]
abstract class Template implements Built<Template, TemplateBuilder> {
  /// Name of the config file
  static const String configFileName = 'template.yaml';

  static final List<Template> _templates = [];

  /// Used for serializing and deserializing data
  static Serializer<Template> get serializer => _$templateSerializer;

  /// Instantiate a [Template] from a given [directory] file,
  /// optionally specify [parent]
  factory Template.fromDirectory(Directory directory, [Template parent]) {
    final config = directory.childFile(configFileName);
    final index = _templates.indexWhere((e) =>
        p.equals(e.config.path, config.path) &&
        (e.parent?.config ?? true) == (parent?.config ?? true));
    if (index >= 0) {
      logger.fine('Using cached instance of template ${directory.path}');
      return _templates[index];
    }

    /// Step 1. Read the yaml file
    final YamlMap yamlMap = loadYaml(config.readAsStringSync());

    /// Step 2. Convert all [YamlNode]s to dart primitives
    final Map<String, dynamic> result = toPrimitive(yamlMap);

    /// Step 3. Deserialize the result
    final deserializedTemplate =
        serializers.deserializeWith(Template.serializer, result).rebuild((b) {
      if (parent != null) {
        b.parent.replace(parent);
      }

      return b.config = config;
    });

    logger.fine('Cached isntance of template ${directory.path}');
    _templates.add(deserializedTemplate);

    return deserializedTemplate;
  }

  Template._();

  /// @internal Should not be used directly
  ///
  /// Use [Template.fromDirectory] instead
  @protected
  factory Template._internal([void updates(TemplateBuilder b)]) = _$Template;

  /// Aggregates context from all of its [include] templates
  /// and adds it's own context
  Context get aggregatedContext {
    Context collective = Context();

    for (var template in includeContext) {
      collective += template.aggregatedContext;
    }

    for (var template in include) {
      collective += template.aggregatedContext;
    }

    return collective + (rawContext ?? Context());
  }

  /// Author of the template
  @nullable
  String get author;

  /// handle to [configFileName]
  @nullable
  File get config;

  /// Expected context to be used for rendering [files]
  @memoized
  Context get context =>
      (parent?.aggregatedContext ?? aggregatedContext) +
      <String, String>{
        'template_name': name,
        'template_desc': desc,
        'template_author': author,
        'template_homepage': homepage,
        'template_version': version,
        'template_license': license,
      };

  /// Description of template
  @nullable
  String get desc;

  /// Root [Directory] of this template
  Directory get directory => getDirectory(config.dirname);

  /// Template files
  @memoized
  List<TemplateFile> get files {
    final HashMap<String, TemplateFile> _files =
        HashMap<String, TemplateFile>(equals: p.equals, hashCode: p.hash);
    final List<TemplateFile> allfiles = [];

    /// Add all files from each include
    include.toList().fold<List<TemplateFile>>(
        allfiles, (List<TemplateFile> acc, Template t) => acc..addAll(t.files));

    /// Add files of this template
    getTemplates(directory)
        .map((f) => TemplateFile(f, this))
        .forEach(allfiles.add);

    _files.addAll(allfiles
        .asMap()
        .map<String, TemplateFile>((_, f) => MapEntry(f.destination.path, f)));

    if (parent == null) {
      if (pubspec == null) {
        logger.warning(TemplateException(
          'Could not generate pubspec template',
          templateLocation: directory.path,
          templateName: name,
        ));
      } else {
        /// Generate and add pubspec.yaml
        final pubspecTemplate = pubspec.generateTemplateFile();

        _files[pubspecTemplate.destination.path] = pubspecTemplate;
        logger
          ..finer('Added in-memory pubspec.yaml for template "$name"')
          ..finest(
            'Pubspec content:\n${pubspecTemplate.source.readAsStringSync()}',
          );
      }
    }

    logger
      ..finer('Generated unique files list for template "$name"')
      ..finest('Files:\n${_files.keys.join('\n')}');

    return _files.values.toList();
  }

  /// While rendering templates, the `.gitignore` of the template can be used
  /// to exclude files from rendering/copying to destination
  @nullable
  bool get gitignore;

  /// Homepage of the template
  @nullable
  String get homepage;

  /// Templates to render before this one
  @memoized
  List<Template> get include =>
      rawInclude
          ?.toList()
          ?.map<Template>((ref) => TemplateRef(ref.toMap(), this)?.template)
          ?.toList() ??
      [];

  /// Templates whose context should be included
  @memoized
  List<Template> get includeContext =>
      rawIncludeContext
          ?.toList()
          ?.map<Template>((ref) => TemplateRef(ref.toMap(), this)?.template)
          ?.toList() ??
      [];

  /// License of the template
  /// Can be a URL or license name
  @nullable
  String get license;

  /// Whether this is a multi-template, used to decide [output] directory
  @memoized
  @nullable
  bool get multiTemplate => parent?.multiTemplate ?? rawMultiTemplate ?? false;

  /// Unique name for the template
  String get name;

  /// Output directory for the template in case multiple templates were
  /// specified for the same project
  ///
  /// this is by default [projectDir], if [output] is specified it's
  /// created as a child directory inside of the project path
  @nullable
  Directory get output {
    if (rawOutput != null && rawOutput.isNotEmpty && multiTemplate) {
      return projectDir.childDirectory(rawOutput);
    }
    return projectDir;
  }

  /// The parent template if it has any
  @nullable
  Template get parent;

  /// Pubspec specific config
  @memoized
  Pubspec get pubspec {
    if (rawPubspec != null) {
      logger.finer('Pubspec found in template "$name"');
      return serializers
          .deserializeWith(
              Pubspec.serializer, toPrimitive<Map>(rawPubspec.asMap()))
          .rebuild((b) => b..parent = toBuilder());
    }

    final Pubspec _pubspec = include.isNotEmpty
        ? include
            .lastWhere((t) => t.pubspec != null)
            .pubspec
            .rebuild((b) => b..parent = toBuilder())
        : null;

    return _pubspec;
  }

  /// @internal Should not be used directly
  ///
  /// Use [context] instead
  @protected
  @nullable
  @BuiltValueField(wireName: 'context')
  Context get rawContext;

  /// @internal Should not be used directly
  ///
  /// Use [include] instead
  @protected
  @nullable
  @BuiltValueField(wireName: 'include')
  BuiltSet<BuiltMap<String, String>> get rawInclude;

  /// @internal Should not be used directly
  ///
  /// Use [includeContext] instead
  @protected
  @nullable
  @BuiltValueField(wireName: 'include_context')
  BuiltSet<BuiltMap<String, String>> get rawIncludeContext;

  /// @internal Should not be used directly
  ///
  /// Use [multiTemplate] instead
  @nullable
  @BuiltValue(wireName: 'multi-template')
  bool get rawMultiTemplate;

  /// @internal Should not be used directly
  ///
  /// Use [output] instead
  @protected
  @nullable
  @BuiltValueField(wireName: 'output')
  String get rawOutput;

  /// @internal Should not be used directly
  ///
  /// Use [pubspec] instead
  @protected
  @nullable
  @BuiltValueField(wireName: 'pubspec')
  BuiltMap<String, JsonObject> get rawPubspec;

  /// Version of this template
  @nullable
  String get version;

  /// Render this template
  void render({bool overwrite = false}) {
    /// This won't be set on any [Exception] or [Error]
    bool success = false;

    if (files != null && files.isNotEmpty) {
      for (var file in files) {
        file.render(overwrite: overwrite);
      }
      success = true;
    }

    if (success) {
      logger.finer('Rendered template "$name"');
    } else {
      throw TemplateException(
        'Tried to render template without any template files ',
        templateName: name,
        templateLocation: directory.path,
      );
    }
  }
}

/// This exception is thrown when [Template.configFileName] has issues
class TemplateException implements Exception {
  /// Explanation for this exception
  final String message;

  /// Name of the template causing this exception
  final String templateName;

  /// Location of the template causing this exception
  final String templateLocation;

  /// Construct a generic exception
  TemplateException(
    this.message, {
    this.templateName = '',
    this.templateLocation = '',
  })  : assert(templateName != null),
        assert(templateLocation != null);

  /// Exception thrown when required template fields are not present or null
  TemplateException.required(
    String field, {
    this.templateName = '',
    this.templateLocation = '',
  })  : message = 'Required field $field is not defined',
        assert(templateName != null),
        assert(templateLocation != null);

  /// Exception thrown when template fields are not of expected type
  TemplateException.typeMisMatch(
    String field,
    String expected,
    String actual, {
    this.templateName = '',
    this.templateLocation = '',
  })  : message = 'Field $field was expected to be $expected but found $actual',
        assert(templateName != null),
        assert(templateLocation != null);

  @override
  String toString() => [
        'TemplateException:',
        message,
        templateName.isNotEmpty
            ? 'template($templateName): $templateLocation'
            : templateLocation,
      ].join('\n');
}

/// [TemplateFile] is a mustache template that knows how and where to render
/// itself
class TemplateFile {
  /// Source file
  File source;

  /// The [Template] this file belongs to
  final Template template;

  /// Whether this template file should only be copied
  bool copyOnly = false;

  /// Whether this template file should be rendered regardless of [copyOnly]
  bool forceRender = false;

  Context _context = Context();

  /// A template [source] to be rendered using the [template] scope
  TemplateFile(this.source, this.template) {
    copyOnly = _relative.contains('.copy');
    forceRender = copyOnly && _relative.endsWith('.tmpl');
  }

  /// The context used for rendering this template
  /// This gets set when [render] is invoked
  Context get context => _context;

  /// Destination where this file should be rendered
  File get destination =>
      template.output.childFile(outputPath(_relative, template.context));

  String get _relative =>
      p.relative(source.path, from: template.directory.path);

  /// Renders the template to the [destination]
  void render({bool overwrite = false}) {
    String content;
    final alreadyExists = destination.existsSync();

    /// If [destination] doesn't exit
    /// Or
    /// If it does exit but we can [overwrite]
    if (!alreadyExists || alreadyExists && overwrite) {
      if (!copyOnly || forceRender) {
        _context = template.context;

        content = renderString(this);
        logger.finer('(Rendered) ${source.path}');
      } else {
        content = source.readAsStringSync();
        logger.finer('(Copied) ${source.path}');
      }

      destination
        ..createSync(recursive: true)
        ..writeAsStringSync(content);

      logger
        ..info(
            ansi.styleBold.wrap('(${alreadyExists ? 'Overwritten' : 'Written'})'
                ' ${destination.path}'))
        ..finest('(Content)\n$content');
    } else {
      logger.info(ansi.styleDim.wrap('(Skipped) ${destination.path}'));

      return;
    }
  }

  /// Returns the expected version of [sourcePath]
  static String outputPath(String sourcePath, Map<String, dynamic> context) =>
      renderString(
          sourcePath.replaceAll(RegExp(r'(\.copy)|(\.tmpl)'), ''), context);
}

/// This is used to create [Template] instances from their paths
class TemplateRef {
  Template _template;

  /// A [ref] can be a name with a path
  TemplateRef(Map<String, String> ref, [Template parent]) {
    if (ref == null) {
      throw ArgumentError.notNull('ref');
    }
    if (ref.keys.length > 1) {
      throw ArgumentError.value(
          ref, 'ref', 'There can only be 1 pair of template name and path');
    }

    final templateName = ref.keys.first;
    final templatePath = ref.values.first;

    /// If [ref] is a direct path to the template
    final directory = fs.directory(templatePath);

    /// If the [ref] is a relatvie path to the parent template
    final relativeToParent =
        getDirectory(p.join(parent?.directory?.path ?? '', templatePath));

    if (directory.existsSync()) {
      _template = Template.fromDirectory(directory, parent);

      logger.finer('$templatePath used as absolute path');
    } else if (relativeToParent.existsSync() && parent != null) {
      _template = Template.fromDirectory(relativeToParent, parent);

      logger.finer('$templatePath used as relative path to parent template');
    }

    /// If [ref] is a unique name of a installed template
    // TODO(devkabiir): make a template registry, https://www.github.com/devkabiir/scaffold/issues/10

    if (templateName != _template.name) {
      throw ArgumentError.value(
          ref, 'ref', "Given name doesn't match the template in path");
    }
  }

  /// The [Template] instance constructed by this
  Template get template => _template;
}
