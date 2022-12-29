import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:ohnost/dashboard.dart';
import 'package:ohnost/notifications.dart';
import 'package:ohnost/profile.dart';
import 'package:ohnost/search.dart';
import 'package:ohnost/secrets.dart';
import 'package:ohnost/settings.dart';
import 'package:ohnost/singlepost.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:routemaster/routemaster.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reflectable/reflectable.dart';

void main() {
  runApp(const MainApp());
}

RoutemasterDelegate routemaster = RoutemasterDelegate(
  routesBuilder: (context) => RouteMap(
    routes: {
      '/': (_) => const IndexedPage(
            child: MainPageStack(),
            paths: [
              '/dashboard',
              '/notifications',
              '/search',
              '/profile/${AppSecrets.currentProjectHandle}'
            ],
          ),
      '/dashboard': (_) => MaterialPage(child: OhnostDashboard()),
      '/notifications': (_) => const MaterialPage(child: OhnostNotifications()),
      '/search': (_) => const MaterialPage(child: SearchPage()),
      '/profile/:handle': (data) =>
          MaterialPage(child: ProfileView(data.pathParameters['handle']!)),
      '/post/:handle/:postId': (data) => MaterialPage(
          child: JustOnePost.fromID(int.parse(data.pathParameters['postId']!),
              data.pathParameters['handle']!)),
      '/settings': (data) => const MaterialPage(child: SettingsPage())
    },
  ),
);

ColorScheme ohnostColorScheme = ColorScheme.fromSeed(seedColor: Colors.pink);
ColorScheme ohnostDarkColorScheme =
    ColorScheme.fromSeed(seedColor: Colors.pink, brightness: Brightness.dark);

BaseCacheManager cacheManager = CacheManager(Config("ohnost",
    stalePeriod: const Duration(hours: 1), maxNrOfCacheObjects: 100));

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return MaterialApp.router(
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: lightColorScheme ?? ohnostColorScheme,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: darkColorScheme ?? ohnostDarkColorScheme,
        ),
        themeMode: ThemeMode.system,
        routerDelegate: routemaster,
        routeInformationParser: const RoutemasterParser(),
        title: "ohnost",
      );
    });
  }
}

class MainPageStack extends StatelessWidget {
  const MainPageStack({super.key});

  @override
  Widget build(BuildContext context) {
    final indexedPage = IndexedPage.of(context);

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          indexedPage.index = index;
        },
        selectedIndex: indexedPage.index,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications),
            label: "Activity",
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: "Search",
          ),
          NavigationDestination(
            icon: Icon(Icons.person_2_outlined),
            selectedIcon: Icon(Icons.person_2),
            label: "You",
          ),
        ],
      ),
      body: PageStackNavigator(
        stack: indexedPage.currentStack,
      ),
    );
  }
}
