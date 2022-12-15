import 'package:flutter/material.dart';
import 'package:ohnost/src/home_page.dart';
import 'package:ohnost/src/user_page.dart';
import 'package:ohnost/src/notifs_page.dart';
import 'package:routemaster/routemaster.dart';

class Routes {
  final routes = RouteMap(routes: {
    '/': (_) => const MaterialPage(child: HomePage()),
    '/notifications': (_) => const MaterialPage(child: NotificationPage()),
    '/user/:id': (route) =>
        MaterialPage(child: UserPage(route.pathParameters['id']!)),
  });
}
