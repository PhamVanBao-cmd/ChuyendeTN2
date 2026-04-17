import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/screens/welcome_screen.dart';
import 'features/auth/screens/welcome_after_login_screen.dart';

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

      /// 🔥 KIỂM TRA LOGIN
      home: const AuthWrapper(),
    );
  }
}

/// 🔥 QUẢN LÝ TRẠNG THÁI ĐĂNG NHẬP
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {

        /// ⏳ loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        /// ❌ CHƯA LOGIN → Welcome
        if (!snapshot.hasData) {
          return const WelcomeScreen();
        }

        /// ✅ ĐÃ LOGIN → WelcomeAfterLogin
        return const WelcomeAfterLoginScreen();
      },
    );
  }
}