import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/screens/welcome_screen.dart'; // 🔥 đổi sang welcome

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health App',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,

      /// 🔥 START TỪ WELCOME
      home: const WelcomeScreen(),
    );
  }
}