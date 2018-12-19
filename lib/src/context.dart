// scaffold, Copyright (C) 2018-Present Dinesh Ahuja <dev@kabiir.me>.
// See the included LICENSE file for more info.

part of scaffold;

// Gets config from local repo if present, global otherwise
// git config --get user.name
// git config --get user.email

/// Context is a map like object that holds variables and values to be used
/// in mustache rendering
class Context extends MapMixin<String, dynamic> {
  /// The context all templates can expect
  static Context defaults = Context(<String, dynamic>{
        'description': 'A new dart project',
        'isWindows': Platform.isWindows,
        'isLinux': Platform.isLinux,
        'isMac': Platform.isMacOS,
      }) *
      {
        'projectName': projectDir.basename,
        'currentDay': DateTime.now().day.toString(),
        'currentMonth': DateTime.now().month.toString(),
        'currentYear': DateTime.now().year.toString(),
        'operatingSystem': Platform.operatingSystem
      };

  /// Underlying map object
  final Map<String, dynamic> data;

  bool _isRendered = false;

  ///
  // ignore: sort_constructors_first
  Context([Map<String, dynamic> map]) : data = map ?? <String, dynamic>{};

  /// Whether all of the [values] are rendered already
  bool get isRendered => _isRendered;

  @override
  Iterable<String> get keys => data.keys;

  /// Applies [_recase] to all entries of [other], adds them to
  /// a copy of [data] and returns a new Context
  Context operator *(Map<String, String> other) {
    final map = toMap();

    other.forEach((k, v) => map.addAll(_recase(k, v)));

    return Context(map);
  }

  /// Returns a new [Context] by adding and overriding all key value pairs from
  /// [other] to this
  Context operator +(Map<String, dynamic> other) =>
      Context(toMap()..addAll(other));

  /// Removes keys from `this` that are present in [other],
  /// it can be a `Map<String, dynamic>,` `List<String>` or `String`
  /// returns a new [Context] with removed key-value pairs
  Context operator -(dynamic other) {
    final result = Context();

    if (other is Map<String, dynamic>) {
      // ignore: avoid_function_literals_in_foreach_calls
      other.keys.forEach((k) => result[k] = remove(k));
    } else if (other is Iterable<String>) {
      // ignore: avoid_function_literals_in_foreach_calls
      other.forEach((k) => result[k] = remove(k));
    } else if (other is String) {
      result[other] = remove(other);
    } else {
      throw ArgumentError.value(other, 'other',
          'it can only be Map<String, dynamic>, List<String> or String');
    }

    return result;
  }

  @override
  dynamic operator [](covariant String key) => data[key];

  @override
  void operator []=(String key, dynamic value) => data[key] = value;

  @override
  void clear() => data.clear();

  @override
  dynamic remove(covariant String key) => data.remove(key);

  /// Returns a copy of [data]
  Map<String, dynamic> toMap() => Map<String, dynamic>.of(data);

  /// Returns rendered view of this context
  Context operator ~() => Context(toMap())
    .._render()
    .._isRendered = true;

  /// Renders itself for nested variable
  void _render() {
    if (isRendered) {
      return;
    }

    forEach((String k, dynamic v) {
      this[k] = _renderValue(v);
    });
  }

  dynamic _renderValue(dynamic value) {
    if (value is String) {
      try {
        /// Render the value using the [context] available at the time
        return mustache.Template(
          value,
          lenient: false,
          htmlEscapeValues: false,
        ).renderString(this + defaults);
      } on mustache.TemplateException catch (e) {
        throw TemplateException(e.toString());
      }
    }

    if (value is Map) {
      final result = <String, dynamic>{};

      // Only need to render the values
      final values = value.values.map<dynamic>(_renderValue).toList();
      final keys = value.keys.cast<String>().toList();
      final length = keys.length;

      for (var i = 0; i < length; i++) {
        result[keys[i]] = values[i];
      }

      return result;
    }

    if (value is Iterable) {
      return value.toList().map<dynamic>(_renderValue);
    }

    /// Anything else is non-renderable
    return value;
  }
}
