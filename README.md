# Danger Clorox

A [Danger](https://github.com/danger/danger) plugin for [Clorox](https://github.com/barbosa/clorox) that runs on macOS.

## Installation

Add this line to your Gemfile:

```rb
gem 'danger-clorox'
```

## Usage

The easiest way to use is just add this to your Dangerfile:

```rb
clorox.directories = ["YourProject", "YourProjectNotificationExtension"]
clorox.check_files
```

## Attribution

Original structure, sequence, and organization of repo taken from [danger-prose](https://github.com/dbgrandi/danger-prose) by [David Grandinetti](https://github.com/dbgrandi/).

## License

MIT
