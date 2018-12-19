import '../lib/{{project_name}}.dart';

void main([List<String> args]) {
  if (args != null) {
    if (args.isEmpty) {
      print('No args given');
    } else {
      print('Following args were given\n${args.join('\n')}');
    }
  }
}
