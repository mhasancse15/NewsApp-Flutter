import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/settings_provider.dart';

class MorePage extends ConsumerWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeMode themeMode = ref.watch(themeModeProvider);
    final ThemeModeNotifier notifier = ref.read(themeModeProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: ListView(
        children: [
          const _SectionLabel('Appearance'),
          RadioListTile<ThemeMode>(
            title: const Text('System'),
            value: ThemeMode.system,
            groupValue: themeMode,
            onChanged: (mode) => notifier.setThemeMode(mode!),
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Light'),
            value: ThemeMode.light,
            groupValue: themeMode,
            onChanged: (mode) => notifier.setThemeMode(mode!),
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Dark'),
            value: ThemeMode.dark,
            groupValue: themeMode,
            onChanged: (mode) => notifier.setThemeMode(mode!),
          ),
          const Divider(),
          const _SectionLabel('About'),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About NewsFlow'),
            onTap: () => _showAboutDialog(context),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            onTap: () => _showPlaceholder(context, 'Privacy Policy'),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Terms & Conditions'),
            onTap: () => _showPlaceholder(context, 'Terms & Conditions'),
          ),
          const ListTile(
            leading: Icon(Icons.numbers_rounded),
            title: Text('App Version'),
            trailing: Text('1.0.0'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'NewsFlow',
      applicationVersion: '1.0.0',
      applicationLegalese: 'Powered by NewsAPI.org',
    );
  }

  void _showPlaceholder(BuildContext context, String title) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: const Text(
          'This is placeholder content. Replace it with your real policy '
          'text before shipping to production.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
