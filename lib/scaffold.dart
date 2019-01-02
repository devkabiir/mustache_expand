// scaffold, Copyright (C) 2018-Present Dinesh Ahuja <dev@kabiir.me>.
// See the included LICENSE file for more info.

/// Core of scaffold
library scaffold;

import 'dart:collection';
import 'dart:io' show Platform;
import 'dart:mirrors';

import 'package:built_value/json_object.dart';
import 'package:file/file.dart';
import 'package:logging/logging.dart';
import 'package:mustache/mustache.dart' as mustache;
import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';
import 'package:yaml/yaml.dart';

import 'src/template.dart';

export 'src/template.dart';

part 'src/context.dart';
part 'src/render.dart';

/// Logging level `FAILED` (value = 1400).
const Level failedLevel = Level('FAILED', 1400);

/// Logging level `SUCCESS` (value = 200).
const Level successLevel = Level('SUCCESS', 200);

/// Logger for `scaffold.core`
final Logger logger = Logger('scaffold.core');

FileSystem _fs;

Directory _projectDir;

/// The filesystem used throughout the library
FileSystem get fs => _fs;

/// Set the filesystem to be used throughout the library
set fs(FileSystem fs) {
  logger.finer('Using filesystem ${fs.runtimeType}');
  _fs = fs;
}

/// Get the working directory for the current project
Directory get projectDir => _projectDir != null
    ? _projectDir
    : throw Exception('Tried to access project directory when it was null');

/// Set the working directory for current project
set projectDir(Directory dir) => _projectDir = dir != null
    ? getDirectory(dir)
    : throw Exception('Project directory cannot be null');

/// Returns normalized absolute version of provided [value]
String cleanPath(String value) =>
    p.canonicalize(p.isAbsolute(value) ? value : p.absolute(value));

/// Returns a directory instance with absolute path and create the directory
/// recursively if it doesn't already exists
///
/// [source] can be a [String] or another [Directory]
Directory getDirectory(dynamic source) {
  String path;

  if (source is String) {
    path = source;
  }
  if (source is Directory) {
    path = source.path;
  }

  return fs.directory(cleanPath(path))..createSync(recursive: true);
}

/// Returns a file instance with absolute path and create the file
/// recursively if it doesn't already exists
///
/// [source] can be a [String] or another [File]
File getFile(dynamic source) {
  String path;

  if (source is String) {
    path = source;
  }
  if (source is File) {
    path = source.path;
  }

  return fs.file(cleanPath(path))..createSync(recursive: true);
}

/// Returns only _sorted_ [File] entities after recursively listing [directory]
/// excludes files with `.dart_tool` in path
List<File> getFiles(Directory directory) => directory
    .listSync(recursive: true)
    .where((entity) => entity is File && !entity.path.contains('.dart_tool'))
    .map<File>((f) => directory.childFile(
        p.relative(cleanPath(f.path), from: directory.absolute.path)))
    .toList()
      ..sort((a, b) => a.path.compareTo(b.path));

/// Returns true when [object] is either one of [bool] | [num] | [String]
bool isPrimitive(dynamic object) =>
    object is bool || object is num || object is String;

/// Converts [thing] to dart primitives
/// Usage: `toPrimitive<Type>(source)`
///
///[thing] can be [JsonObject], [YamlNode] or any dart primitive
///
/// here [Type] being explicit like `List<String>` don't work in general
/// `List<dynamic>` works as expected
T toPrimitive<T>(dynamic thing) {
  dynamic result;

  /// In case it's already a dart primitive
  if (thing is T && isPrimitive(thing)) {
    return thing;
  }

  if (thing is Iterable) {
    result = thing.toList().map<dynamic>(toPrimitive).toList();
  } else if (thing is Map) {
    final List<String> keys = thing.keys.cast<String>().toList();
    final List<dynamic> values = toPrimitive<List>(thing.values.toList());
    result = Map<String, dynamic>.fromIterables(keys, values);
  } else if (thing is YamlNode) {
    /// `value` here holds the underlying primitive
    result = toPrimitive<dynamic>(thing.value);
  } else if (thing is JsonObject) {
    /// `value` here holds the underlying primitive
    result = toPrimitive<dynamic>(thing.value);
  }

  if (result is T) {
    return result;
  }

  throw ArgumentError([
    'Thing:[${thing.runtimeType}] ${thing.toString()} conversion to $T failed',
    'Result:[${result.runtimeType}] ${result.toString()}',
  ].join('\n'));
}

/// Returns a map of all valid cases of [key] and corresponding [value]
Map<String, String> _recase(String key, String value) {
  final result = <String, String>{};
  final recaseClass = reflectClass(ReCase);
  final caseGetters = recaseClass.declarations.values
      .where((d) => !d.isPrivate && d.simpleName != const Symbol('ReCase'))
      .map((dec) => dec.simpleName);
  final reCasedKey = recaseClass.newInstance(const Symbol(''), <String>[key]);
  final reCasedValue =
      recaseClass.newInstance(const Symbol(''), <String>[value]);

  for (var getterName in caseGetters) {
    /// Here using `putIfAbsent` because some cases may output string equal to
    /// already existing case
    result.putIfAbsent(reCasedKey.getField(getterName).reflectee.toString(),
        () => reCasedValue.getField(getterName).reflectee.toString());
  }

  return result;
}
