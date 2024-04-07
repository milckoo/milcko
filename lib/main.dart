import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:milcko/screens/home_screen.dart';
import 'package:milcko/Screens/splash_screen.dart';
import 'package:milcko/screens/getstarted_screen.dart';
import 'package:milcko/firebase_options.dart';
import 'package:milcko/provider/auth_provider.dart';
import 'package:milcko/provider/location_provider.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
  // AuthProvider access = new AuthProvider();
  // access.recreateUsersCollection().then((_) {
  //   runApp(
  //     MultiProvider(
  //       providers: [
  //         ChangeNotifierProvider(
  //           //create: (_) => AuthProvider(),
  //         ),
  //         ChangeNotifierProvider(
  //           create: (_) => LocationProvider(),
  //         )
  //       ],
  //       child: const MyApp(),)
  //   );
  // });
  // runApp(
  //   MultiProvider(
  //     providers: [
  //       ChangeNotifierProvider(
  //         create: (_) => AuthProvider(),
  //       ),
  //       ChangeNotifierProvider(
  //         create: (_) => LocationProvider(),
  //       )
  //       ],
  //       child: const MyApp(),)
  // );
}

class MyApp extends StatelessWidget {
  const MyApp({key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
    // MultiProvider(
    //   providers: [ChangeNotifierProvider(create: (_)=> AuthProvider())],
    //   child: const MaterialApp(
    //     debugShowCheckedModeBanner: false,
    //     initialRoute: SplashScreen.id,
    //     routes: {
    //       HomeScreen.id: (context) => const HomeScreen(),
    //       GetStartedScreen.id: (context) => const GetStartedScreen(),
    //       SplashScreen.id: (context) => const SplashScreen(),
    //     }
    //   ),
    // );
  }
}
