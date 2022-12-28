import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:master_app/Provider/contactProvider.dart';
import 'package:master_app/Provider/Firebase/fire_auth.dart';
import 'package:master_app/Provider/dreamProvider.dart';
import 'package:master_app/Provider/homeProvider.dart';
import 'package:provider/provider.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'Pages/LogIn.dart';
import 'Pages/Purchase/MarketPage.dart';
// import 'Pages/Purchase/old_purchase.dart';
// import 'Pages/Purchase/purchase.dart';
import 'Preferencias/sharedPeference.dart';
import 'Provider/Firebase/fire_store.dart';
import 'Provider/bigData.dart';
import 'Provider/navProvider.dart';
import 'Provider/playerProvider.dart';
import 'local_notification/local_notification.dart';
import 'navegationPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await Firebase.initializeApp();
  await NotificationService().setup();
  final prefs = PreferenciasUsuario();
  await prefs.initPrefs();
  AssetsAudioPlayer.setupNotificationsOpenAction((notification) {
    return true;
  });

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
        ChangeNotifierProvider(create: (_) => PlayerProvider()),
        ChangeNotifierProvider(create: (_) => FireAuth()),
        ChangeNotifierProvider(create: (_) => FireStore()),
        ChangeNotifierProvider(create: (_) => BigData()),
        ChangeNotifierProvider(create: (_) => DreamProvider()),
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
        home: const SignIn(),
      ),
    );
  }
}
