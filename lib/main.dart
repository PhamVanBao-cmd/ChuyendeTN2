import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';

import 'core/theme/app_theme.dart';
import 'core/services/notification_service.dart';

import 'features/auth/screens/welcome_screen.dart';
import 'features/auth/screens/welcome_after_login_screen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  /// FIREBASE
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// NOTIFICATION
  await NotificationService.init();

  /// FOREGROUND TASK
  FlutterForegroundTask.init(

    androidNotificationOptions:
    AndroidNotificationOptions(

      channelId: 'health_foreground',

      channelName: 'Health Service',

      channelDescription:
      'Theo dõi bước chân nền',

      channelImportance:
      NotificationChannelImportance.LOW,

      priority: NotificationPriority.LOW,
    ),

    iosNotificationOptions:
    const IOSNotificationOptions(),

    foregroundTaskOptions:
    ForegroundTaskOptions(

      eventAction:
      ForegroundTaskEventAction.repeat(
        5000,
      ),

      autoRunOnBoot: true,

      autoRunOnMyPackageReplaced: true,

      allowWakeLock: true,

      allowWifiLock: true,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      title: 'Health App',

      theme: AppTheme.lightTheme,

      home: const AuthWrapper(),
    );
  }
}

/// ================= AUTH WRAPPER =================

class AuthWrapper extends StatelessWidget {

  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<User?>(

      stream:
      FirebaseAuth.instance.authStateChanges(),

      builder: (context, snapshot) {

        if (snapshot.connectionState ==
            ConnectionState.waiting) {

          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const WelcomeScreen();
        }

        return const WelcomeAfterLoginScreen();
      },
    );
  }
}