import 'dart:convert';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:ohnost/composer/composer.dart';
import 'package:ohnost/dashboard.dart';
import 'package:ohnost/db.dart';
import 'package:ohnost/model.dart';
import 'package:ohnost/notifications/notifications.dart';
import 'package:ohnost/profile.dart';
import 'package:ohnost/search/search.dart';
import 'package:ohnost/secrets.dart';
import 'package:ohnost/settings.dart';
import 'package:ohnost/tags.dart';
import 'package:ohnost/singlepost.dart';
import 'package:routemaster/routemaster.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  runApp(const MainApp());
}

RoutemasterDelegate routemaster = RoutemasterDelegate(
  routesBuilder: (context) => RouteMap(
    routes: {
      '/': (_) => const TabPage(
            child: MainPageStack(),
            paths: [
              '/dashboard',
              '/notifications',
              '/search',
              '/profile/${AppSecrets.currentProjectHandle}'
            ],
          ),
      '/dashboard': (_) => const MaterialPage(child: OhnostDashboard()),
      '/notifications': (_) => const MaterialPage(child: OhnostNotifications()),
      '/search': (_) => const MaterialPage(child: SearchPage()),
      '/profile/:handle': (data) => MaterialPage(
          key: ValueKey("profile-${data.pathParameters['handle']!}"),
          child: ProfileView(data.pathParameters['handle']!)),
      '/post/:handle/:postId': (data) {
        /* 
          if you were thinking it was silly that we need to serialise and then
          deserialse the post just to get it through the router, it is!
          but this is the route i have chosen.
        */
        if (data.queryParameters.containsKey('post')) {
          Post post = Post.fromJson(jsonDecode(data.queryParameters['post']!));
          return MaterialPage(
            key: ValueKey(post.postId.toString()),
            child: JustOnePost(post),
          );
        }
        return MaterialPage(
          key: ValueKey(data.pathParameters['postId']!),
          child: JustOnePost.fromID(
            int.parse(data.pathParameters['postId']!),
            data.pathParameters['handle']!,
          ),
        );
      },
      '/tag/:tag': (data) => MaterialPage(
          child: TagPage(
            Uri.decodeFull(data.pathParameters['tag']!),
            key: ValueKey(
              data.pathParameters['tag']!,
            ),
          ),
          maintainState: false),
      '/settings': (data) => const MaterialPage(child: SettingsPage()),
      '/compose': (data) => MaterialPage(child: PostComposer()),
      '/share/:handle/:id': (data) => MaterialPage(
            child: PostComposer.share(
                postId: int.parse(data.pathParameters['id']!),
                handle: data.pathParameters['handle']!),
          ),
      '/comment/:id': (data) => MaterialPage(
            child: PostComposer.comment(
              postId: int.parse(data.pathParameters['id']!),
            ),
          ),
    },
  ),
);

ColorScheme ohnostColorScheme = ColorScheme.fromSeed(seedColor: Colors.pink);
ColorScheme ohnostDarkColorScheme =
    ColorScheme.fromSeed(seedColor: Colors.pink, brightness: Brightness.dark);

BaseCacheManager cacheManager = CacheManager(Config("ohnost-cache",
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
    final tabPage = TabPage.of(context);

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          tabPage.controller.index = index;
        },
        selectedIndex: tabPage.controller.index,
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
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabPage.controller,
        children: [
          for (final stack in tabPage.stacks) PageStackNavigator(stack: stack),
        ],
      ),
    );
  }
}
