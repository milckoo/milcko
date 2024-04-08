import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:milcko/Screens/splash_screen.dart';
import 'package:milcko/firebase_options.dart';
import 'package:milcko/provider/auth_provider.dart';
import 'package:milcko/provider/location_provider.dart';
import 'package:milcko/screens/getstarted_screen.dart';
import 'package:milcko/screens/home_screen.dart';
import 'package:milcko/screens/map_screen.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocationProvider(),
        )
        ],
        child: const MyApp(),)
  );
}

class MyApp extends StatelessWidget {
  const MyApp({key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return 
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_)=> AuthProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreen.id,
        routes: {
          HomeScreen.id: (context) => const  HomeScreen(),
          GetStartedScreen.id: (context) => const GetStartedScreen(),
          SplashScreen.id: (context) => const SplashScreen(),
          MapScreen.id: (context) => const MapScreen(),
        }
      ),
    );
  }
}
