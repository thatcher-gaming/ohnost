import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/services.dart';
import 'package:ohnost/src/app.dart';

import './router.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

/// The Widget that configures your application.
class OhnostApp extends StatefulWidget {
  const OhnostApp({
    super.key,
    required this.settingsController,
  });

  @override
  State createState() {
    return OhnostAppState();
  }

  final SettingsController settingsController;
}

class OhnostAppState extends State<OhnostApp> {
  OhnostAppState() {
    final router = FluroRouter();
    Routes.configureRoutes(router);
    Application.router = router;
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      // make status bar transparent on android (ios does this by default i believe)
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          statusBarColor: Color.fromARGB(0, 0, 0, 0)));
    }

    return WidgetsApp(
      color: Colors.white,
      onGenerateRoute: Application.router.generator,
      textStyle:
          const TextStyle(color: Colors.black, fontFamily: 'Roboto Serif'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
      ],
    );
  }
}
