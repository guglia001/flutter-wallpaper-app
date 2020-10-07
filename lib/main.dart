import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:provider/provider.dart';
import 'package:random_color_scheme/random_color_scheme.dart';
import 'package:wallpaper_dope/src/localizations.dart';
import 'package:wallpaper_dope/src/models/uploads_model.dart';
import 'package:wallpaper_dope/src/pages/page_controller.dart';
import 'package:wallpaper_dope/src/providers/home_providers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wallpaper_dope/src/providers/trending_provider.dart';
import 'package:wallpaper_dope/src/providers/uploads_provider.dart';

void main() {
  runApp(Theme(
      data: ThemeData(
        colorScheme: randomColorSchemeDark(),
      ),
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    Permission.storage.request();

    final firebase = Firebase.initializeApp();
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          return MultiProvider(
              providers: [
                ChangeNotifierProvider(
                    create: (_) => BottomNavigationBarProvider()),
                ChangeNotifierProvider(create: (_) => HomeProviderUnsplash()),
                ChangeNotifierProvider(create: (_) => UploadsProvider()),
                ChangeNotifierProvider(create: (_) => TrendingProvider()),
                ChangeNotifierProvider(create: (_) => UploadsModel())
              ],
              child: MaterialApp(
                  localizationsDelegates: [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  supportedLocales: [
                    Locale('en', ''),
                    Locale('es' '')
                  ],
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(accentColor: Colors.red[400]),
                  title: 'Wallpaper App',
                  // home: UploadForm()));
                  home: ControllerPage()));
        });
  }
}
//TODO: arreglar al poner el fondo de pantalla se buguea , demora mucho poner loading screens
