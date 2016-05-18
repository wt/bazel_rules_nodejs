# NodeJS support for Bazel

## Introduction

[Bazel](http://bazel.io/) is a build system released as open source by Google.
It's primary feature is that it's designed from top to bottom for
hermetically sound builds without requiring a full rebuild.

This project is an extension for Bazel to add the capability to build nodejs
projects.

## Usage

### Enabling in Your Project

Add the following to your WORKSPACE:

```python
git_repository(
    name="org_penguintechs_bazel_rules_nodejs",
    remote="https://github.com/wt/bazel_rules_nodejs.git",
    commit="<appropriate SHA1 for some commit>",
)

load("@org_penguintechs_bazel_rules_nodejs//nodejs:def.bzl",
     "nodejs_repositories")
nodejs_repositories()
```

Eventually, I will change use using tags for versions. These are early days.

### Using the Rules

#### nodejs_binary

Args:

* name
* main_script - the file that is the main script to run

## Contributing

First of all, thanks for thinking about contributing.

I'd eventually like to contribute this back to Google to host in the
[bazelbuild](https://github.com/bazelbuild/) GitHub org at some point.
Please make sure this is something you can get behind before contributing.

Send me a PR. I prefer small atomic and reviewable changes in each PR.

Also, please file issues if you don't have time to write up a code change for
your idea.

## Todos

* Add some testing
* Add rules to import libs from npm and other sources.
* Add ability to generate one file for deployment, something like
  [nar](https://github.com/h2non/nar).
