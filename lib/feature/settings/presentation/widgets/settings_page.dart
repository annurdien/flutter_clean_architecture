import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            subtitle: Text(_getLanguageName(context.locale)),
            onTap: () => _showLanguageDialog(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () => _showAboutDialog(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Back to Home'),
            onTap: () => context.router.navigatePath('/'),
          ),
        ],
      ),
    );
  }

  String _getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      default:
        return locale.languageCode;
    }
  }

  void _showLanguageDialog(BuildContext context) {
    final supported = context.supportedLocales;
    final current = context.locale;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: supported
              .map(
                (locale) => ListTile(
                  title: Text(_getLanguageName(locale)),
                  leading: Radio<Locale>(
                    value: locale,
                    groupValue: current,
                    onChanged: (value) async {
                      if (value != null && value != current) {
                        await context.setLocale(value);
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      }
                    },
                  ),
                ),
              )
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Flutter Clean Architecture',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.flutter_dash, size: 48),
      children: const [
        Text(
          'A clean architecture Flutter application with auto_route navigation.',
        ),
      ],
    );
  }
}
