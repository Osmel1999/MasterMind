import 'package:flutter/material.dart';
import 'package:master_app/Provider/contactProvider.dart';
import 'package:master_app/Provider/homeProvider.dart';
import 'package:provider/provider.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'Preferencias/sharedPeference.dart';
import 'Provider/navProvider.dart';
import 'local_notification/local_notification.dart';
import 'navegationPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await NotificationService().setup();
  final prefs = PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DynamicBoxProvider()),
        ChangeNotifierProvider(create: (_) => ContactProvider()),
        ChangeNotifierProvider(create: (_) => AgendaProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English, no country code
          Locale('es', ''), // Spanish, no country code
        ],
        debugShowCheckedModeBanner: false,
        title: 'Master App',
        theme: ThemeData(backgroundColor: Colors.white
            // primarySwatch: Colors.blueAccent!,
            ),
        home: const NavigationPage(),
      ),
    );
  }
}
