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
    apiKey: 'AIzaSyBQB_cJegOWKdVQtfVjwW_Z_EdSPMdGKT0',
    appId: '1:735761103681:web:00b1d723a0dad6d8f0bfc0',
    messagingSenderId: '735761103681',
    projectId: 'pemmobile-cf293',
    authDomain: 'pemmobile-cf293.firebaseapp.com',
    storageBucket: 'pemmobile-cf293.appspot.com',
    measurementId: 'G-RV2H700P5T',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDKjNMuOKAagnOi41byExchU0PT4JCxObU',
    appId: '1:735761103681:android:8f978af0450c1797f0bfc0',
    messagingSenderId: '735761103681',
    projectId: 'pemmobile-cf293',
    storageBucket: 'pemmobile-cf293.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAP26Bbi4i9lsJgp6TttYsjgnScXa7hqTU',
    appId: '1:735761103681:ios:27cdd2521248475ff0bfc0',
    messagingSenderId: '735761103681',
    projectId: 'pemmobile-cf293',
    storageBucket: 'pemmobile-cf293.appspot.com',
    iosBundleId: 'com.example.uasPemmobile',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAP26Bbi4i9lsJgp6TttYsjgnScXa7hqTU',
    appId: '1:735761103681:ios:27cdd2521248475ff0bfc0',
    messagingSenderId: '735761103681',
    projectId: 'pemmobile-cf293',
    storageBucket: 'pemmobile-cf293.appspot.com',
    iosBundleId: 'com.example.uasPemmobile',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBQB_cJegOWKdVQtfVjwW_Z_EdSPMdGKT0',
    appId: '1:735761103681:web:766546fc423f5685f0bfc0',
    messagingSenderId: '735761103681',
    projectId: 'pemmobile-cf293',
    authDomain: 'pemmobile-cf293.firebaseapp.com',
    storageBucket: 'pemmobile-cf293.appspot.com',
    measurementId: 'G-67LB1Y77BK',
  );

}