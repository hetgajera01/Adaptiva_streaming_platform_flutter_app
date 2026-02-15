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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // Firebase configuration for adaptive-streaming-platform project
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDFaC7zQ8p9IXQbllH1TZbzj5eiyI-CfC0',
    appId: '1:832908471700:android:60777a8561d2eecbd33381', // Using Android ID temporarily
    messagingSenderId: '832908471700',
    projectId: 'adaptive-streaming-platform',
    authDomain: 'adaptive-streaming-platform.firebaseapp.com',
    databaseURL: 'https://adaptive-streaming-platform-default-rtdb.firebaseio.com',
    storageBucket: 'adaptive-streaming-platform.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDFaC7zQ8p9IXQbllH1TZbzj5eiyI-CfC0',
    appId: '1:832908471700:android:60777a8561d2eecbd33381',
    messagingSenderId: '832908471700',
    projectId: 'adaptive-streaming-platform',
    databaseURL: 'https://adaptive-streaming-platform-default-rtdb.firebaseio.com',
    storageBucket: 'adaptive-streaming-platform.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDFaC7zQ8p9IXQbllH1TZbzj5eiyI-CfC0',
    appId: '1:832908471700:ios:YOUR_IOS_APP_ID', // Add iOS app in Firebase Console if needed
    messagingSenderId: '832908471700',
    projectId: 'adaptive-streaming-platform',
    databaseURL: 'https://adaptive-streaming-platform-default-rtdb.firebaseio.com',
    storageBucket: 'adaptive-streaming-platform.firebasestorage.app',
    iosBundleId: 'com.example.madProject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDFaC7zQ8p9IXQbllH1TZbzj5eiyI-CfC0',
    appId: '1:832908471700:ios:YOUR_IOS_APP_ID',
    messagingSenderId: '832908471700',
    projectId: 'adaptive-streaming-platform',
    databaseURL: 'https://adaptive-streaming-platform-default-rtdb.firebaseio.com',
    storageBucket: 'adaptive-streaming-platform.firebasestorage.app',
    iosBundleId: 'com.example.madProject',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDFaC7zQ8p9IXQbllH1TZbzj5eiyI-CfC0',
    appId: '1:832908471700:android:60777a8561d2eecbd33381', // Using Android config for Windows
    messagingSenderId: '832908471700',
    projectId: 'adaptive-streaming-platform',
    authDomain: 'adaptive-streaming-platform.firebaseapp.com',
    databaseURL: 'https://adaptive-streaming-platform-default-rtdb.firebaseio.com',
    storageBucket: 'adaptive-streaming-platform.firebasestorage.app',
  );
}
