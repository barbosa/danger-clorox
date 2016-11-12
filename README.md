[![CircleCI](https://circleci.com/gh/barbosa/danger-clorox.svg?style=svg)](https://circleci.com/gh/barbosa/danger-clorox)

# Danger Clorox

A [Danger](https://github.com/danger/danger) plugin for [Clorox](https://github.com/barbosa/clorox) that runs on macOS.

```diff
+//
+//  DirtyFile.swift
+//  MyApp
+//
+//  Created by John Appleseed on 11/12/16.
+//  Copyright © 2016 ACME. All rights reserved.
+//
+
+import Foundation
```

:-1:

## Installation

Add this line to your Gemfile:

```rb
gem 'danger-clorox'
```

## Usage

### Basic

Add the following line to your Danger file to check files inside the current directory:
```rb
clorox.check
```

### Advanced

Specify the directories where you want to run the script:
```rb
clorox.check ["YourProject", "YourProjectNotificationExtension"]
```

Set the script level so it displays failures/warnings in the specific markdown table
```rb
clorox.level = "failure"
clorox.check ["YourProject", "YourProjectNotificationExtension"]
```

### Output

<table>
  <thead>
    <tr>
      <th width="50"></th>
      <th width="100%" data-danger-table="true" data-kind="Error">
          1 Error
      </th>
     </tr>
  </thead>
  <tbody>

    <tr>
      <td>:no_entry_sign:</td>
      <td data-sticky="false">MyApp/Source/DirtyFile.swift contains Xcode's file header</td>
    </tr>
  </tbody>
</table>
<table>

## Attribution

Original structure, sequence, and organization of repo taken from [danger-prose](https://github.com/dbgrandi/danger-prose) by [David Grandinetti](https://github.com/dbgrandi/) and [danger-swiftlint](https://github.com/ashfurrow/danger-swiftlint) by [Ash Furrow](https://github.com/ashfurrow/).

## License

MIT
