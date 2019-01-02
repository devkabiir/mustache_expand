# {{ProjectName}}

{{# shields}}
[![{{alt_text}}][{{alias}}]][{{link_alias}}]
{{/ shields}}

## About

{{description}}

## Usage

## :busts_in_silhouette: Contributing

- :fork_and_knife: Fork this repo

- :arrow_down: Clone your forked version  
  `git clone https://github.com/<you>/{{project_name}}.git`

- :heavy_plus_sign: Add this repo as a remote  
  `git remote add upstream {{github_repo_url}}.git`

- :arrow_double_down: Make sure you have recent changes  
  `git fetch upstream`

- :sparkles: Make a new branch with your proposed changes/fixes/additions  
  `git checkout upstream/master -b name_of_your_branch`

- :bookmark_tabs: Make sure you follow guidelines for [Git](#git)

- :arrow_double_up: Push your changes  
  `git push origin name_of_your_branch`

- :arrows_clockwise: Make a pull request

## :octocat: Git

- :heavy_check_mark: Sign all commits. Learn about [signing-commits]
- Use [commitizen] with [cz-emoji] adapter
- Check existing commits to get an idea
- Run the pre_commit script from project root `pub run pre_commit`
- If you're adding an `and` in your commit message, it should probably be separate commits
- Link relevant issues/commits with a `#` sign in the commit message
- Limit message length per line to 72 characters (excluding space required for linking issues/commits)
- Add commit description if message isn't enough for explaining changes

## :lipstick: Code style

- Maintain consistencies using included `.editorconfig`
- Everything else as per standard dart [guidelines]

## :white_check_mark: Testing

- Add tests for each new addition/feature
- Do not remove/change tests when refactoring
  - unless fixing already broken test.

## :sparkles: Features and :bug:bugs

Please file feature requests and bugs at the [issue-tracker].

## :scroll: License

Copyright (C) {{currentYear}}-Present {{#authors}}{{full_name}} <{{email}}>{{/authors}}.

Please see the [LICENSE] file in this repository for the full text

<!-- Shield aliases -->
{{# shields}}
[{{alias}}]: https://img.shields.io{{path}}
{{/ shields}}

<!-- Link aliases -->
{{# links}}
[{{alias}}]: {{url}}
{{/ links}}
