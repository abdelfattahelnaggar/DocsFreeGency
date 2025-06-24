# Localization in FreeGency

This project uses the [easy_localization](https://pub.dev/packages/easy_localization) package for localization.

## Current Setup

### Supported Languages
- English (en)
- Arabic (ar)

### Translation Files
Translation files are located in the `assets/translations` directory:
- `en.json` - English translations
- `ar.json` - Arabic translations

## How to Use Localization in Your Code

### Basic Usage

To translate a string:
```dart
// Using context.tr()
Text(context.tr('key_name'))
```

### Using Plurals

For plural translation:
```dart
// Using TR.plural()
Text(context.plural('key_name', count))
```

### Using Named Arguments

For translations with named arguments:
```dart
// Using named arguments
Text(context.tr('key_name', namedArgs: {'arg_name': value}))
```

## Adding New Keys

1. Add your key to both `en.json` and `ar.json` files.
2. Use a consistent naming convention (snake_case recommended).
3. Group related keys together.

Example:
```json
{
  "feature_name": {
    "action": "Action Label",
    "title": "Feature Title"
  }
}
```

## Adding a New Language

1. Create a new JSON file in the `assets/translations` directory (e.g., `fr.json` for French).
2. Copy all keys from `en.json` and translate the values.
3. Add the new locale to the supported locales in `main.dart`:

```dart
EasyLocalization(
  supportedLocales: const [Locale('en'), Locale('ar'), Locale('fr')],
  // ...
)
```

## Changing Language

The app includes a language selector widget that can be accessed from the settings screen. You can also change the language programmatically:

```dart
// Change to English
context.setLocale(const Locale('en'));

// Change to Arabic
context.setLocale(const Locale('ar'));
```

## Best Practices

1. **Don't hardcode strings** - Always use translation keys.
2. **Keep keys organized** - Group related keys together.
3. **Use descriptive keys** - Make keys self-explanatory (e.g., `login_button` instead of `button1`).
4. **Test in all languages** - Especially for layout issues with RTL languages like Arabic.
5. **Use the language selector widget** - For easy language switching.

## Resources

- [easy_localization Documentation](https://pub.dev/packages/easy_localization)
- [Flutter Internationalization Guide](https://docs.flutter.dev/development/accessibility-and-localization/internationalization) 