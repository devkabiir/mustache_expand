# [WIP] Scaffold

[![LICENSE][LICENSE-shield]][LICENSE]
[![Build status][travis-shield]][repo]
[![Code coverage][code-coverage-shield]][repo]
[![Pub version][pub-version-shield]][pub-link]
[![Commitizen friendly][commitizen-shield]][commitizen]
[![Commitizen style][commitizen-style-shield]][cz-emoji]
[![Maintained][maintenance-shield]][repo]

## About

CLI app for assisting dart developers

## Usage

### As a global package

```sh
pub global activate -sgit https://www.github.com/devkabiir/scaffold
```

Give it a path to template and output directory

```sh
scaffold create my_app --template=<path/to/template>
```

This will expand to the `my_app` directory

### As a dependency

```yaml
dependencies:
  ...
  scaffold:
    git: https://www.github.com/devkabiir/scaffold
```

```dart
import 'package:scaffold/scaffold.dart' as scaffold;

void main() => print();

```

## Contributing

- :fork_and_knife: Fork this repo
- Clone your forked version  
  `git clone https://github.com/<you>/scaffold.git`

- :heavy_plus_sign: Add this repo as a remote  
  `git remote add upstream https://github.com/devkabiir/scaffold.git`

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

Copyright (C) 2018-Present Dinesh Ahuja <dev@kabiir.me>.

Please see the [LICENSE] file in this repository for the full text

<!-- Shield aliases -->
[LICENSE-shield]: https://img.shields.io/badge/license-MIT-brightgreen.svg
[travis-shield]: https://img.shields.io/travis/com/devkabiir/scaffold.svg
[code-coverage-shield]: https://img.shields.io/codecov/c/github/devkabiir/scaffold.svg
[pub-version-shield]: https://img.shields.io/pub/v/scaffold.svg
[commitizen-shield]: https://img.shields.io/badge/commitizen-friendly-brightgreen.svg
[commitizen-style-shield]: https://img.shields.io/badge/commitizen--style-emoji-brightgreen.svg
[maintenance-shield]: https://img.shields.io/maintenance/yes/2018.svg


<!-- Link aliases -->
[cz-emoji]: https://github.com/ngryman/cz-emoji
[commitizen]: http://commitizen.github.io/cz-cli/
[pub-link]: https://pub.dartlang.org/packages/scaffold
[repo]: https://github.com/devkabiir/scaffold
[guidelines]: https://www.dartlang.org/guides/language/effective-dart/style
[signing-commits]: https://help.github.com/articles/signing-commits/
[issue-tracker]: https://github.com/devkabiir/scaffold/issues
[LICENSE]: https://github.com/devkabiir/scaffold/blob/master/LICENSE
