import 'package:demo/firebase_options.dart';
import 'package:demo/global/global.dart';
import 'package:demo/provider/form_state.dart';
import 'package:demo/splashScreen/splash_sreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(

      providers: [
        ChangeNotifierProvider(create: (c) => LoginFormData()),
        ChangeNotifierProvider(create: (c) => RegisterFormData()),
      ],
      child: MaterialApp(
        title: 'FoodBlood',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: SplashSreen(),
      ),
    );
  }
}
