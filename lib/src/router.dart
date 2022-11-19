// ignore_for_file: avoid_print

import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';
import 'package:ohnost/src/home.dart';
import 'package:ohnost/src/user_page.dart';

class Routes {
  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      print("ah. fuck");
      return;
    });

    router.define('/', handler: rootHandler);
    router.define('/user/:handle', handler: userHandler);
  }
}

var rootHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  return const HomePage();
});

var userHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  return UserPage(params['handle']![0]);
});
