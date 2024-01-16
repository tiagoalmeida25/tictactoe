// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCyqEODYzmgGbUgbe1gBirs2Pqrwzn8718',
    appId: '1:494204492585:web:2cf0e63fc54f40696ff538',
    messagingSenderId: '494204492585',
    projectId: 'tictactoe-40831',
    authDomain: 'tictactoe-40831.firebaseapp.com',
    storageBucket: 'tictactoe-40831.appspot.com',
    measurementId: 'G-CP7GTB8LCZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDKhwAuhzo31_MoGYKQlNG0kdJotA-IjTg',
    appId: '1:494204492585:android:2c15b9ad04c04efd6ff538',
    messagingSenderId: '494204492585',
    projectId: 'tictactoe-40831',
    storageBucket: 'tictactoe-40831.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCyqsiCkhjEC0nAOgwtGcD8Gj2jKqFljI4',
    appId: '1:494204492585:ios:35f711a4042652f56ff538',
    messagingSenderId: '494204492585',
    projectId: 'tictactoe-40831',
    storageBucket: 'tictactoe-40831.appspot.com',
    iosBundleId: 'com.tiagoalmeida.tictactoe',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCyqsiCkhjEC0nAOgwtGcD8Gj2jKqFljI4',
    appId: '1:494204492585:ios:d35e07ea29d69a5b6ff538',
    messagingSenderId: '494204492585',
    projectId: 'tictactoe-40831',
    storageBucket: 'tictactoe-40831.appspot.com',
    iosBundleId: 'com.example.tictactoe.RunnerTests',
  );
}