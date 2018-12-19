// scaffold, Copyright (C) 2018-Present Dinesh Ahuja <dev@kabiir.me>.
// See the included LICENSE file for more info.

part of scaffold;

/// Special context variable that evaluates the source inside the tag
final Map<String, mustache.LambdaFunction> lambda = {
  '_': (mustache.LambdaContext ctx, [String value]) {
    logger.finest('ctx.source: ${ctx.source}');
    // final test = '${ctx.source}';
    // print(currentMirrorSystem()
    //     .isolate
    //     .loadUri(Uri.parse('package:scaffold/scaffold.dart')));
    final parts = ctx.source.split('.');
    // final dot = ctx.lookup('.');
    // logger.finest('ctx.lookup(.):\n$dot');
    final varName = reflect(toPrimitive<List>(ctx.lookup(parts.first)));

    print(varName);
    print(varName.type.declarations.containsKey(Symbol(parts[1])));
    print(varName.type.declarations);
    print(varName.getField(Symbol(parts[1])).reflectee);

    // final rendered = ctx.renderString(value: {'map': dot});
    // logger.finest('(Rendered) ctx.source:\n$rendered');

    return 'rendered';
  }
};

/// Returns the renderd version of [value] using [context],
/// [value] can be [TemplateFile] or [String], any other object is
/// converted to string using `toString`
/// adds [Context.defaults] regardless of [context] being specified
String renderString(
  dynamic value, [
  Map<String, dynamic> context,
]) {
  TemplateFile templateFile;
  if (value is TemplateFile) {
    templateFile = value;
  }
  try {
    /// Render the value using the [context] available at the time
    return mustache.Template(
      templateFile?.source?.readAsStringSync() ?? value.toString(),
      lenient: false,
      htmlEscapeValues: false,
      name: templateFile?.source?.path,
    ).renderString((~Context(templateFile?.context ?? context)) +
        Context.defaults +
        lambda);
  } on mustache.TemplateException catch (e) {
    final message = [
      e.toString(),
    ].join('\n');
    throw TemplateException(
      message,
      templateLocation: templateFile?.template?.directory?.path ?? '',
      templateName: templateFile?.template?.name ?? '',
    );
  }
}
