# obscured_preferences

This package makes use of [shared_preferences](https://pub.dartlang.org/packages/shared_preferences) and [encrypt](https://pub.dartlang.org/packages/encrypt) packages to provide encrypted shared preferences.

## Usage

The syntax and usage of this package is the same as that of [shared_preferences](https://pub.dartlang.org/packages/shared_preferences).

```dart
import 'package:flutter/material.dart';
import 'package:obscured_preferences/obscured_preferences.dart';


void savePrefs() async {

    ObscuredPrefs prefs = await ObscuredPrefs.getInstance();

    await prefs.setString('key', 'Hello World!');

    final strValue = prefs.getString('key');
}
```


