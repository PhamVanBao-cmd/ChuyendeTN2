import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyB27WOErtBzKDSr0DVI4ArZQ_5IfCUUbDc",
    authDomain: "theodoisuckhoe-app.firebaseapp.com",
    projectId: "theodoisuckhoe-app",
    storageBucket: "theodoisuckhoe-app.firebasestorage.app",
    messagingSenderId: "612547382090",
    appId: "1:612547382090:web:112be32f074ed3e1e98fb3",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyB27WOErtBzKDSr0DVI4ArZQ_5IfCUUbDc",
    appId: "1:612547382090:web:112be32f074ed3e1e98fb3",
    messagingSenderId: "612547382090",
    projectId: "theodoisuckhoe-app",
    storageBucket: "theodoisuckhoe-app.firebasestorage.app",
  );
}