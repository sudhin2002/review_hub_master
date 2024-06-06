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
    apiKey: 'AIzaSyBYvJzmwEY8atrqCH0Xj4pR5ChFk5b2H7w',
    appId: '1:206394666942:web:80e0c5b3bf9dcf09bed3ef',
    messagingSenderId: '206394666942',
    projectId: 'review-hub-4e698',
    authDomain: 'review-hub-4e698.firebaseapp.com',
    storageBucket: 'review-hub-4e698.appspot.com',
    measurementId: 'G-CW46XJ9GX0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDNTZkI7LDbRi0hrPWZBVzpRm6ZbBnkOzA',
    appId: '1:206394666942:android:04d38e8c73df226ebed3ef',
    messagingSenderId: '206394666942',
    projectId: 'review-hub-4e698',
    storageBucket: 'review-hub-4e698.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDm6HiO_YPFebX6Bmx5-dXMS8ROILOz8_o',
    appId: '1:206394666942:ios:2af35894976447e7bed3ef',
    messagingSenderId: '206394666942',
    projectId: 'review-hub-4e698',
    storageBucket: 'review-hub-4e698.appspot.com',
    iosBundleId: 'com.example.reviewHubAdmin',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBYvJzmwEY8atrqCH0Xj4pR5ChFk5b2H7w',
    appId: '1:206394666942:web:5aaea3a1efc6388abed3ef',
    messagingSenderId: '206394666942',
    projectId: 'review-hub-4e698',
    authDomain: 'review-hub-4e698.firebaseapp.com',
    storageBucket: 'review-hub-4e698.appspot.com',
    measurementId: 'G-9WXSSYXEQW',
  );
}