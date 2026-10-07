import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/login_page.dart';
import '../features/capture/presentation/capture_page.dart';
import '../features/library/presentation/library_page.dart';
import '../features/settings/presentation/settings_page.dart';

class VisinfoApp extends StatelessWidget {
  const VisinfoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Visinfo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      routerConfig: _router,
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/login',
  routes: <RouteBase>[
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) => const LoginPage(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (BuildContext context, GoRouterState state, StatefulNavigationShell navigationShell) {
        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: navigationShell.goBranch,
            destinations: const <NavigationDestination>[
              NavigationDestination(icon: Icon(Icons.photo_library_outlined), label: 'Library'),
              NavigationDestination(icon: Icon(Icons.camera_alt_outlined), label: 'Capture'),
              NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Settings'),
            ],
          ),
        );
      },
      branches: <StatefulShellBranch>[
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/library',
              builder: (BuildContext context, GoRouterState state) => const LibraryPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/capture',
              builder: (BuildContext context, GoRouterState state) => const CapturePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/settings',
              builder: (BuildContext context, GoRouterState state) => const SettingsPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
