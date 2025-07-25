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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBdMx_sHmC_K0eWaypRVby9YWFBtw6DyNw',
    appId: '1:95259164117:web:994de37639b176cbc3915c',
    messagingSenderId: '95259164117',
    projectId: 'furnestra-e7654',
    authDomain: 'furnestra-e7654.firebaseapp.com',
    storageBucket: 'furnestra-e7654.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBAo5lohbV32s4Ug95IURw1zz7kK5d8Vck',
    appId: '1:95259164117:android:da26b4b0b6f55a61c3915c',
    messagingSenderId: '95259164117',
    projectId: 'furnestra-e7654',
    storageBucket: 'furnestra-e7654.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBFjPPAON6lweja35UEH1dgj3IszEuMixo',
    appId: '1:95259164117:ios:946455f1a556a4edc3915c',
    messagingSenderId: '95259164117',
    projectId: 'furnestra-e7654',
    storageBucket: 'furnestra-e7654.firebasestorage.app',
    iosBundleId: 'com.example.furnitureAr',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBdMx_sHmC_K0eWaypRVby9YWFBtw6DyNw',
    appId: '1:95259164117:web:e28c517607884edbc3915c',
    messagingSenderId: '95259164117',
    projectId: 'furnestra-e7654',
    authDomain: 'furnestra-e7654.firebaseapp.com',
    storageBucket: 'furnestra-e7654.firebasestorage.app',
  );
}
