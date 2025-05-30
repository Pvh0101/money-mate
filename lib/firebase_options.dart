// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyB1IfhEZbd0bVKdJk-Kw7IWIuHMBCJFSwI',
    appId: '1:911509380555:web:497b59e1f50e7feefbaa4e',
    messagingSenderId: '911509380555',
    projectId: 'e-commerce-project-70c8e',
    authDomain: 'e-commerce-project-70c8e.firebaseapp.com',
    storageBucket: 'e-commerce-project-70c8e.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA7ZrBikz_aEogDO6_ueCn-wFNfA0ON9ds',
    appId: '1:911509380555:android:c4d959421480e1fdfbaa4e',
    messagingSenderId: '911509380555',
    projectId: 'e-commerce-project-70c8e',
    storageBucket: 'e-commerce-project-70c8e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBasqOPcCWe6zOlF0fYT6wF7QAbsvbDY_Y',
    appId: '1:911509380555:ios:5c64ea59edf6dd7cfbaa4e',
    messagingSenderId: '911509380555',
    projectId: 'e-commerce-project-70c8e',
    storageBucket: 'e-commerce-project-70c8e.appspot.com',
    iosBundleId: 'com.example.moneyMate',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBasqOPcCWe6zOlF0fYT6wF7QAbsvbDY_Y',
    appId: '1:911509380555:ios:5c64ea59edf6dd7cfbaa4e',
    messagingSenderId: '911509380555',
    projectId: 'e-commerce-project-70c8e',
    storageBucket: 'e-commerce-project-70c8e.appspot.com',
    iosBundleId: 'com.example.moneyMate',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCzQ23cpQ0YYFpsV40IQVxSEh294mKwhvw',
    appId: '1:911509380555:web:9ccc6612f89dae5afbaa4e',
    messagingSenderId: '911509380555',
    projectId: 'e-commerce-project-70c8e',
    authDomain: 'e-commerce-project-70c8e.firebaseapp.com',
    storageBucket: 'e-commerce-project-70c8e.appspot.com',
  );
}
