import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/application/auth_providers.dart';
import '../../sync/application/sync_providers.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'V1 foundation:\n'
              '- Email/password auth\n'
              '- Cloud sync\n'
              '- Free plan with billing-ready feature gates',
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () async {
                await ref.read(syncQueueServiceProvider).processOnce();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sync cycle completed')),
                  );
                }
              },
              child: const Text('Run one sync cycle'),
            ),
            const SizedBox(height: 8),
            FilledButton.tonal(
              onPressed: () async {
                await ref.read(authServiceProvider).signOut();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Signed out')),
                  );
                }
              },
              child: const Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }
}
