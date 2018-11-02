# Mustache Expand

[![License](https://img.shields.io/github/license/devkabiir/mustache_expand.svg)][LICENSE]
[![Travis build](https://img.shields.io/travis/com/devkabiir/mustache_expand.svg)][repo]
[![Commitizen friendly](https://img.shields.io/badge/commitizen-friendly-brightgreen.svg)][commitizen]
[![Commitizen style](https://img.shields.io/badge/commitizen--style-emoji-brightgreen.svg)][cz-emoji]

## About

Given a context, expands mustache templates with it

## Usage

### As a global package

```sh
pub global activate -sgit https://www.github.com/devkabiir/mustache_expand
```

Give it a `context.json`, path to template and output directory

```sh
mustache_expand --context=template.context.json --template=<path/to/template> .
```

This will expand to the current working directory

By default it takes the `context.json` from the current working directory if found,
or takes it from the `<user-directory>/<template_name>.context.json` if present, otherwise
you can specify it via the `--context` flag

If `<user-directory>/mustache.context.json` exists, it gets _merged_ with the `context.json` found in
the previous step

### As a dependency

```yaml
dependencies:
  ...
  mustache_expand:
    git: https://www.github.com/devkabiir/mustache_expand
```

```dart
import 'package:mustache_expand/mustache_expand.dart' as mustache_expand;

void main() => print();

```

## Contributing

- :fork_and_knife: Fork this repo
- Clone your forked version  
  `git clone https://github.com/<you>/mustache_expand.git`

- :heavy_plus_sign: Add this repo as a remote  
  `git remote add upstream https://github.com/devkabiir/mustache_expand.git`

- :arrow_double_up: Make sure you have recent changes  
  `git fetch upstream`

- :sparkles: Make a new branch with your proposed changes/fixes/additions  
  `git checkout upstream/master -b name_of_your_branch`

- :bookmark_tabs: Make sure you follow guidelines for [Git](#git)
- Push your changes  
  `git push origin name_of_your_branch`

- Make a pull request

## Git

- :white_check_mark: Sign all commits. Learn about [signing-commits]
- Use [commitizen] with [cz-emoji] adapter
- Check existing commits to get an idea
- Run the pre_commit script from project root `pub run pre_commit`
- If you're adding an `and` in your commit message, it should probably be separate commits
- Link relevant issues/commits with a `#` sign in the commit message
- Limit message length per line to 72 characters (excluding space required for linking issues/commits)
- Add commit description if message isn't enough for explaining changes

## Code style

- Maintain consistencies using included `.editorconfig`
- Everything else as per standard dart [guidelines]

## Testing

- Add tests for each new addition/feature
- Do not remove/change tests when refactoring
  - unless fixing already broken test.

## Features and bugs

Please file feature requests and bugs at the [issue-tracker].

## License

Copyright (C) 2018 Dinesh Ahuja <dev@kabiir.me>

Please see the [LICENSE] file in this repository for the full text

[repo]: https://github.com/devkabiir/mustache_expand
[guidelines]: https://www.dartlang.org/guides/language/effective-dart/style
[commitizen]: http://commitizen.github.io/cz-cli/
[cz-emoji]: https://github.com/ngryman/cz-emoji
[signing-commits]: https://help.github.com/articles/signing-commits/
[issue-tracker]: https://www.github.com/devkabiir/mustache_expand/issues
[LICENSE]: https://github.com/devkabiir/mustache_expand/blob/master/LICENSE
