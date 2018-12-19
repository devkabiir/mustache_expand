// GENERATED CODE - DO NOT MODIFY BY HAND

part of scaffold.template;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$serializers = (new Serializers().toBuilder()
      ..add(Pubspec.serializer)
      ..add(Template.serializer)
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(String), const FullType(JsonObject)]),
          () => new MapBuilder<String, JsonObject>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(String), const FullType(JsonObject)]),
          () => new MapBuilder<String, JsonObject>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(String), const FullType(JsonObject)]),
          () => new MapBuilder<String, JsonObject>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(String)]),
          () => new MapBuilder<String, String>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(String)]),
          () => new MapBuilder<String, String>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(String), const FullType(JsonObject)]),
          () => new MapBuilder<String, JsonObject>())
      ..addBuilderFactory(
          const FullType(BuiltSet, const [
            const FullType(BuiltMap,
                const [const FullType(String), const FullType(String)])
          ]),
          () => new SetBuilder<BuiltMap<String, String>>())
      ..addBuilderFactory(
          const FullType(BuiltSet, const [
            const FullType(BuiltMap,
                const [const FullType(String), const FullType(String)])
          ]),
          () => new SetBuilder<BuiltMap<String, String>>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(String), const FullType(JsonObject)]),
          () => new MapBuilder<String, JsonObject>()))
    .build();
Serializer<Pubspec> _$pubspecSerializer = new _$PubspecSerializer();
Serializer<Template> _$templateSerializer = new _$TemplateSerializer();

class _$PubspecSerializer implements StructuredSerializer<Pubspec> {
  @override
  final Iterable<Type> types = const [Pubspec, _$Pubspec];
  @override
  final String wireName = 'Pubspec';

  @override
  Iterable serialize(Serializers serializers, Pubspec object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.author != null) {
      result
        ..add('author')
        ..add(serializers.serialize(object.author,
            specifiedType: const FullType(String)));
    }
    if (object.authors != null) {
      result
        ..add('authors')
        ..add(serializers.serialize(object.authors,
            specifiedType:
                const FullType(BuiltList, const [const FullType(String)])));
    }
    if (object.dependencies != null) {
      result
        ..add('dependencies')
        ..add(serializers.serialize(object.dependencies,
            specifiedType: const FullType(BuiltMap,
                const [const FullType(String), const FullType(JsonObject)])));
    }
    if (object.dependencyOverrides != null) {
      result
        ..add('dependency_overrides')
        ..add(serializers.serialize(object.dependencyOverrides,
            specifiedType: const FullType(BuiltMap,
                const [const FullType(String), const FullType(JsonObject)])));
    }
    if (object.description != null) {
      result
        ..add('description')
        ..add(serializers.serialize(object.description,
            specifiedType: const FullType(String)));
    }
    if (object.devDependencies != null) {
      result
        ..add('dev_dependencies')
        ..add(serializers.serialize(object.devDependencies,
            specifiedType: const FullType(BuiltMap,
                const [const FullType(String), const FullType(JsonObject)])));
    }
    if (object.documentation != null) {
      result
        ..add('documentation')
        ..add(serializers.serialize(object.documentation,
            specifiedType: const FullType(String)));
    }
    if (object.environment != null) {
      result
        ..add('environment')
        ..add(serializers.serialize(object.environment,
            specifiedType: const FullType(BuiltMap,
                const [const FullType(String), const FullType(String)])));
    }
    if (object.executables != null) {
      result
        ..add('executables')
        ..add(serializers.serialize(object.executables,
            specifiedType: const FullType(BuiltMap,
                const [const FullType(String), const FullType(String)])));
    }
    if (object.flutter != null) {
      result
        ..add('flutter')
        ..add(serializers.serialize(object.flutter,
            specifiedType: const FullType(BuiltMap,
                const [const FullType(String), const FullType(JsonObject)])));
    }
    if (object.homepage != null) {
      result
        ..add('homepage')
        ..add(serializers.serialize(object.homepage,
            specifiedType: const FullType(String)));
    }
    if (object.parent != null) {
      result
        ..add('parent')
        ..add(serializers.serialize(object.parent,
            specifiedType: const FullType(Template)));
    }
    if (object.publishTo != null) {
      result
        ..add('publish_to')
        ..add(serializers.serialize(object.publishTo,
            specifiedType: const FullType(String)));
    }
    if (object.version != null) {
      result
        ..add('version')
        ..add(serializers.serialize(object.version,
            specifiedType: const FullType(String)));
    }

    return result;
  }

  @override
  Pubspec deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PubspecBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'author':
          result.author = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'authors':
          result.authors.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList);
          break;
        case 'dependencies':
          result.dependencies.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, const [
                const FullType(String),
                const FullType(JsonObject)
              ])) as BuiltMap);
          break;
        case 'dependency_overrides':
          result.dependencyOverrides.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, const [
                const FullType(String),
                const FullType(JsonObject)
              ])) as BuiltMap);
          break;
        case 'description':
          result.description = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'dev_dependencies':
          result.devDependencies.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, const [
                const FullType(String),
                const FullType(JsonObject)
              ])) as BuiltMap);
          break;
        case 'documentation':
          result.documentation = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'environment':
          result.environment.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, const [
                const FullType(String),
                const FullType(String)
              ])) as BuiltMap);
          break;
        case 'executables':
          result.executables.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, const [
                const FullType(String),
                const FullType(String)
              ])) as BuiltMap);
          break;
        case 'flutter':
          result.flutter.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, const [
                const FullType(String),
                const FullType(JsonObject)
              ])) as BuiltMap);
          break;
        case 'homepage':
          result.homepage = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'parent':
          result.parent.replace(serializers.deserialize(value,
              specifiedType: const FullType(Template)) as Template);
          break;
        case 'publish_to':
          result.publishTo = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'version':
          result.version = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$TemplateSerializer implements StructuredSerializer<Template> {
  @override
  final Iterable<Type> types = const [Template, _$Template];
  @override
  final String wireName = 'Template';

  @override
  Iterable serialize(Serializers serializers, Template object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
    ];
    if (object.author != null) {
      result
        ..add('author')
        ..add(serializers.serialize(object.author,
            specifiedType: const FullType(String)));
    }
    if (object.config != null) {
      result
        ..add('config')
        ..add(serializers.serialize(object.config,
            specifiedType: const FullType(File)));
    }
    if (object.desc != null) {
      result
        ..add('desc')
        ..add(serializers.serialize(object.desc,
            specifiedType: const FullType(String)));
    }
    if (object.gitignore != null) {
      result
        ..add('gitignore')
        ..add(serializers.serialize(object.gitignore,
            specifiedType: const FullType(bool)));
    }
    if (object.homepage != null) {
      result
        ..add('homepage')
        ..add(serializers.serialize(object.homepage,
            specifiedType: const FullType(String)));
    }
    if (object.license != null) {
      result
        ..add('license')
        ..add(serializers.serialize(object.license,
            specifiedType: const FullType(String)));
    }
    if (object.parent != null) {
      result
        ..add('parent')
        ..add(serializers.serialize(object.parent,
            specifiedType: const FullType(Template)));
    }
    if (object.rawContext != null) {
      result
        ..add('context')
        ..add(serializers.serialize(object.rawContext,
            specifiedType: const FullType(Context)));
    }
    if (object.rawInclude != null) {
      result
        ..add('include')
        ..add(serializers.serialize(object.rawInclude,
            specifiedType: const FullType(BuiltSet, const [
              const FullType(BuiltMap,
                  const [const FullType(String), const FullType(String)])
            ])));
    }
    if (object.rawIncludeContext != null) {
      result
        ..add('include_context')
        ..add(serializers.serialize(object.rawIncludeContext,
            specifiedType: const FullType(BuiltSet, const [
              const FullType(BuiltMap,
                  const [const FullType(String), const FullType(String)])
            ])));
    }
    if (object.rawMultiTemplate != null) {
      result
        ..add('rawMultiTemplate')
        ..add(serializers.serialize(object.rawMultiTemplate,
            specifiedType: const FullType(bool)));
    }
    if (object.rawOutput != null) {
      result
        ..add('output')
        ..add(serializers.serialize(object.rawOutput,
            specifiedType: const FullType(String)));
    }
    if (object.rawPubspec != null) {
      result
        ..add('pubspec')
        ..add(serializers.serialize(object.rawPubspec,
            specifiedType: const FullType(BuiltMap,
                const [const FullType(String), const FullType(JsonObject)])));
    }
    if (object.version != null) {
      result
        ..add('version')
        ..add(serializers.serialize(object.version,
            specifiedType: const FullType(String)));
    }

    return result;
  }

  @override
  Template deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new TemplateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'author':
          result.author = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'config':
          result.config = serializers.deserialize(value,
              specifiedType: const FullType(File)) as File;
          break;
        case 'desc':
          result.desc = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'gitignore':
          result.gitignore = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'homepage':
          result.homepage = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'license':
          result.license = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'parent':
          result.parent.replace(serializers.deserialize(value,
              specifiedType: const FullType(Template)) as Template);
          break;
        case 'context':
          result.rawContext = serializers.deserialize(value,
              specifiedType: const FullType(Context)) as Context;
          break;
        case 'include':
          result.rawInclude.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltSet, const [
                const FullType(BuiltMap,
                    const [const FullType(String), const FullType(String)])
              ])) as BuiltSet);
          break;
        case 'include_context':
          result.rawIncludeContext.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltSet, const [
                const FullType(BuiltMap,
                    const [const FullType(String), const FullType(String)])
              ])) as BuiltSet);
          break;
        case 'rawMultiTemplate':
          result.rawMultiTemplate = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'output':
          result.rawOutput = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'pubspec':
          result.rawPubspec.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, const [
                const FullType(String),
                const FullType(JsonObject)
              ])) as BuiltMap);
          break;
        case 'version':
          result.version = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$Pubspec extends Pubspec {
  @override
  final String author;
  @override
  final BuiltList<String> authors;
  @override
  final BuiltMap<String, JsonObject> dependencies;
  @override
  final BuiltMap<String, JsonObject> dependencyOverrides;
  @override
  final String description;
  @override
  final BuiltMap<String, JsonObject> devDependencies;
  @override
  final String documentation;
  @override
  final BuiltMap<String, String> environment;
  @override
  final BuiltMap<String, String> executables;
  @override
  final BuiltMap<String, JsonObject> flutter;
  @override
  final String homepage;
  @override
  final Template parent;
  @override
  final String publishTo;
  @override
  final String version;

  factory _$Pubspec([void updates(PubspecBuilder b)]) =>
      (new PubspecBuilder()..update(updates)).build();

  _$Pubspec._(
      {this.author,
      this.authors,
      this.dependencies,
      this.dependencyOverrides,
      this.description,
      this.devDependencies,
      this.documentation,
      this.environment,
      this.executables,
      this.flutter,
      this.homepage,
      this.parent,
      this.publishTo,
      this.version})
      : super._();

  @override
  Pubspec rebuild(void updates(PubspecBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  PubspecBuilder toBuilder() => new PubspecBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Pubspec &&
        author == other.author &&
        authors == other.authors &&
        dependencies == other.dependencies &&
        dependencyOverrides == other.dependencyOverrides &&
        description == other.description &&
        devDependencies == other.devDependencies &&
        documentation == other.documentation &&
        environment == other.environment &&
        executables == other.executables &&
        flutter == other.flutter &&
        homepage == other.homepage &&
        parent == other.parent &&
        publishTo == other.publishTo &&
        version == other.version;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc(
                                        $jc(
                                            $jc(
                                                $jc(
                                                    $jc($jc(0, author.hashCode),
                                                        authors.hashCode),
                                                    dependencies.hashCode),
                                                dependencyOverrides.hashCode),
                                            description.hashCode),
                                        devDependencies.hashCode),
                                    documentation.hashCode),
                                environment.hashCode),
                            executables.hashCode),
                        flutter.hashCode),
                    homepage.hashCode),
                parent.hashCode),
            publishTo.hashCode),
        version.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Pubspec')
          ..add('author', author)
          ..add('authors', authors)
          ..add('dependencies', dependencies)
          ..add('dependencyOverrides', dependencyOverrides)
          ..add('description', description)
          ..add('devDependencies', devDependencies)
          ..add('documentation', documentation)
          ..add('environment', environment)
          ..add('executables', executables)
          ..add('flutter', flutter)
          ..add('homepage', homepage)
          ..add('parent', parent)
          ..add('publishTo', publishTo)
          ..add('version', version))
        .toString();
  }
}

class PubspecBuilder implements Builder<Pubspec, PubspecBuilder> {
  _$Pubspec _$v;

  String _author;
  String get author => _$this._author;
  set author(String author) => _$this._author = author;

  ListBuilder<String> _authors;
  ListBuilder<String> get authors =>
      _$this._authors ??= new ListBuilder<String>();
  set authors(ListBuilder<String> authors) => _$this._authors = authors;

  MapBuilder<String, JsonObject> _dependencies;
  MapBuilder<String, JsonObject> get dependencies =>
      _$this._dependencies ??= new MapBuilder<String, JsonObject>();
  set dependencies(MapBuilder<String, JsonObject> dependencies) =>
      _$this._dependencies = dependencies;

  MapBuilder<String, JsonObject> _dependencyOverrides;
  MapBuilder<String, JsonObject> get dependencyOverrides =>
      _$this._dependencyOverrides ??= new MapBuilder<String, JsonObject>();
  set dependencyOverrides(MapBuilder<String, JsonObject> dependencyOverrides) =>
      _$this._dependencyOverrides = dependencyOverrides;

  String _description;
  String get description => _$this._description;
  set description(String description) => _$this._description = description;

  MapBuilder<String, JsonObject> _devDependencies;
  MapBuilder<String, JsonObject> get devDependencies =>
      _$this._devDependencies ??= new MapBuilder<String, JsonObject>();
  set devDependencies(MapBuilder<String, JsonObject> devDependencies) =>
      _$this._devDependencies = devDependencies;

  String _documentation;
  String get documentation => _$this._documentation;
  set documentation(String documentation) =>
      _$this._documentation = documentation;

  MapBuilder<String, String> _environment;
  MapBuilder<String, String> get environment =>
      _$this._environment ??= new MapBuilder<String, String>();
  set environment(MapBuilder<String, String> environment) =>
      _$this._environment = environment;

  MapBuilder<String, String> _executables;
  MapBuilder<String, String> get executables =>
      _$this._executables ??= new MapBuilder<String, String>();
  set executables(MapBuilder<String, String> executables) =>
      _$this._executables = executables;

  MapBuilder<String, JsonObject> _flutter;
  MapBuilder<String, JsonObject> get flutter =>
      _$this._flutter ??= new MapBuilder<String, JsonObject>();
  set flutter(MapBuilder<String, JsonObject> flutter) =>
      _$this._flutter = flutter;

  String _homepage;
  String get homepage => _$this._homepage;
  set homepage(String homepage) => _$this._homepage = homepage;

  TemplateBuilder _parent;
  TemplateBuilder get parent => _$this._parent ??= new TemplateBuilder();
  set parent(TemplateBuilder parent) => _$this._parent = parent;

  String _publishTo;
  String get publishTo => _$this._publishTo;
  set publishTo(String publishTo) => _$this._publishTo = publishTo;

  String _version;
  String get version => _$this._version;
  set version(String version) => _$this._version = version;

  PubspecBuilder();

  PubspecBuilder get _$this {
    if (_$v != null) {
      _author = _$v.author;
      _authors = _$v.authors?.toBuilder();
      _dependencies = _$v.dependencies?.toBuilder();
      _dependencyOverrides = _$v.dependencyOverrides?.toBuilder();
      _description = _$v.description;
      _devDependencies = _$v.devDependencies?.toBuilder();
      _documentation = _$v.documentation;
      _environment = _$v.environment?.toBuilder();
      _executables = _$v.executables?.toBuilder();
      _flutter = _$v.flutter?.toBuilder();
      _homepage = _$v.homepage;
      _parent = _$v.parent?.toBuilder();
      _publishTo = _$v.publishTo;
      _version = _$v.version;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Pubspec other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Pubspec;
  }

  @override
  void update(void updates(PubspecBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$Pubspec build() {
    _$Pubspec _$result;
    try {
      _$result = _$v ??
          new _$Pubspec._(
              author: author,
              authors: _authors?.build(),
              dependencies: _dependencies?.build(),
              dependencyOverrides: _dependencyOverrides?.build(),
              description: description,
              devDependencies: _devDependencies?.build(),
              documentation: documentation,
              environment: _environment?.build(),
              executables: _executables?.build(),
              flutter: _flutter?.build(),
              homepage: homepage,
              parent: _parent?.build(),
              publishTo: publishTo,
              version: version);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'authors';
        _authors?.build();
        _$failedField = 'dependencies';
        _dependencies?.build();
        _$failedField = 'dependencyOverrides';
        _dependencyOverrides?.build();

        _$failedField = 'devDependencies';
        _devDependencies?.build();

        _$failedField = 'environment';
        _environment?.build();
        _$failedField = 'executables';
        _executables?.build();
        _$failedField = 'flutter';
        _flutter?.build();

        _$failedField = 'parent';
        _parent?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Pubspec', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$Template extends Template {
  @override
  final String author;
  @override
  final File config;
  @override
  final String desc;
  @override
  final bool gitignore;
  @override
  final String homepage;
  @override
  final String license;
  @override
  final String name;
  @override
  final Template parent;
  @override
  final Context rawContext;
  @override
  final BuiltSet<BuiltMap<String, String>> rawInclude;
  @override
  final BuiltSet<BuiltMap<String, String>> rawIncludeContext;
  @override
  final bool rawMultiTemplate;
  @override
  final String rawOutput;
  @override
  final BuiltMap<String, JsonObject> rawPubspec;
  @override
  final String version;
  Context __context;
  List<TemplateFile> __files;
  List<Template> __include;
  List<Template> __includeContext;
  bool __multiTemplate;
  Pubspec __pubspec;

  factory _$Template([void updates(TemplateBuilder b)]) =>
      (new TemplateBuilder()..update(updates)).build();

  _$Template._(
      {this.author,
      this.config,
      this.desc,
      this.gitignore,
      this.homepage,
      this.license,
      this.name,
      this.parent,
      this.rawContext,
      this.rawInclude,
      this.rawIncludeContext,
      this.rawMultiTemplate,
      this.rawOutput,
      this.rawPubspec,
      this.version})
      : super._() {
    if (name == null) {
      throw new BuiltValueNullFieldError('Template', 'name');
    }
  }

  @override
  Context get context => __context ??= super.context;

  @override
  List<TemplateFile> get files => __files ??= super.files;

  @override
  List<Template> get include => __include ??= super.include;

  @override
  List<Template> get includeContext =>
      __includeContext ??= super.includeContext;

  @override
  bool get multiTemplate => __multiTemplate ??= super.multiTemplate;

  @override
  Pubspec get pubspec => __pubspec ??= super.pubspec;

  @override
  Template rebuild(void updates(TemplateBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  TemplateBuilder toBuilder() => new TemplateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Template &&
        author == other.author &&
        config == other.config &&
        desc == other.desc &&
        gitignore == other.gitignore &&
        homepage == other.homepage &&
        license == other.license &&
        name == other.name &&
        parent == other.parent &&
        rawContext == other.rawContext &&
        rawInclude == other.rawInclude &&
        rawIncludeContext == other.rawIncludeContext &&
        rawMultiTemplate == other.rawMultiTemplate &&
        rawOutput == other.rawOutput &&
        rawPubspec == other.rawPubspec &&
        version == other.version;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc(
                                        $jc(
                                            $jc(
                                                $jc(
                                                    $jc(
                                                        $jc(
                                                            $jc(
                                                                0,
                                                                author
                                                                    .hashCode),
                                                            config.hashCode),
                                                        desc.hashCode),
                                                    gitignore.hashCode),
                                                homepage.hashCode),
                                            license.hashCode),
                                        name.hashCode),
                                    parent.hashCode),
                                rawContext.hashCode),
                            rawInclude.hashCode),
                        rawIncludeContext.hashCode),
                    rawMultiTemplate.hashCode),
                rawOutput.hashCode),
            rawPubspec.hashCode),
        version.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Template')
          ..add('author', author)
          ..add('config', config)
          ..add('desc', desc)
          ..add('gitignore', gitignore)
          ..add('homepage', homepage)
          ..add('license', license)
          ..add('name', name)
          ..add('parent', parent)
          ..add('rawContext', rawContext)
          ..add('rawInclude', rawInclude)
          ..add('rawIncludeContext', rawIncludeContext)
          ..add('rawMultiTemplate', rawMultiTemplate)
          ..add('rawOutput', rawOutput)
          ..add('rawPubspec', rawPubspec)
          ..add('version', version))
        .toString();
  }
}

class TemplateBuilder implements Builder<Template, TemplateBuilder> {
  _$Template _$v;

  String _author;
  String get author => _$this._author;
  set author(String author) => _$this._author = author;

  File _config;
  File get config => _$this._config;
  set config(File config) => _$this._config = config;

  String _desc;
  String get desc => _$this._desc;
  set desc(String desc) => _$this._desc = desc;

  bool _gitignore;
  bool get gitignore => _$this._gitignore;
  set gitignore(bool gitignore) => _$this._gitignore = gitignore;

  String _homepage;
  String get homepage => _$this._homepage;
  set homepage(String homepage) => _$this._homepage = homepage;

  String _license;
  String get license => _$this._license;
  set license(String license) => _$this._license = license;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  TemplateBuilder _parent;
  TemplateBuilder get parent => _$this._parent ??= new TemplateBuilder();
  set parent(TemplateBuilder parent) => _$this._parent = parent;

  Context _rawContext;
  Context get rawContext => _$this._rawContext;
  set rawContext(Context rawContext) => _$this._rawContext = rawContext;

  SetBuilder<BuiltMap<String, String>> _rawInclude;
  SetBuilder<BuiltMap<String, String>> get rawInclude =>
      _$this._rawInclude ??= new SetBuilder<BuiltMap<String, String>>();
  set rawInclude(SetBuilder<BuiltMap<String, String>> rawInclude) =>
      _$this._rawInclude = rawInclude;

  SetBuilder<BuiltMap<String, String>> _rawIncludeContext;
  SetBuilder<BuiltMap<String, String>> get rawIncludeContext =>
      _$this._rawIncludeContext ??= new SetBuilder<BuiltMap<String, String>>();
  set rawIncludeContext(
          SetBuilder<BuiltMap<String, String>> rawIncludeContext) =>
      _$this._rawIncludeContext = rawIncludeContext;

  bool _rawMultiTemplate;
  bool get rawMultiTemplate => _$this._rawMultiTemplate;
  set rawMultiTemplate(bool rawMultiTemplate) =>
      _$this._rawMultiTemplate = rawMultiTemplate;

  String _rawOutput;
  String get rawOutput => _$this._rawOutput;
  set rawOutput(String rawOutput) => _$this._rawOutput = rawOutput;

  MapBuilder<String, JsonObject> _rawPubspec;
  MapBuilder<String, JsonObject> get rawPubspec =>
      _$this._rawPubspec ??= new MapBuilder<String, JsonObject>();
  set rawPubspec(MapBuilder<String, JsonObject> rawPubspec) =>
      _$this._rawPubspec = rawPubspec;

  String _version;
  String get version => _$this._version;
  set version(String version) => _$this._version = version;

  TemplateBuilder();

  TemplateBuilder get _$this {
    if (_$v != null) {
      _author = _$v.author;
      _config = _$v.config;
      _desc = _$v.desc;
      _gitignore = _$v.gitignore;
      _homepage = _$v.homepage;
      _license = _$v.license;
      _name = _$v.name;
      _parent = _$v.parent?.toBuilder();
      _rawContext = _$v.rawContext;
      _rawInclude = _$v.rawInclude?.toBuilder();
      _rawIncludeContext = _$v.rawIncludeContext?.toBuilder();
      _rawMultiTemplate = _$v.rawMultiTemplate;
      _rawOutput = _$v.rawOutput;
      _rawPubspec = _$v.rawPubspec?.toBuilder();
      _version = _$v.version;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Template other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Template;
  }

  @override
  void update(void updates(TemplateBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$Template build() {
    _$Template _$result;
    try {
      _$result = _$v ??
          new _$Template._(
              author: author,
              config: config,
              desc: desc,
              gitignore: gitignore,
              homepage: homepage,
              license: license,
              name: name,
              parent: _parent?.build(),
              rawContext: rawContext,
              rawInclude: _rawInclude?.build(),
              rawIncludeContext: _rawIncludeContext?.build(),
              rawMultiTemplate: rawMultiTemplate,
              rawOutput: rawOutput,
              rawPubspec: _rawPubspec?.build(),
              version: version);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'parent';
        _parent?.build();

        _$failedField = 'rawInclude';
        _rawInclude?.build();
        _$failedField = 'rawIncludeContext';
        _rawIncludeContext?.build();

        _$failedField = 'rawPubspec';
        _rawPubspec?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Template', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
