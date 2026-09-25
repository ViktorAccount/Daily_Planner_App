import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb, TargetPlatform, defaultTargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
        return macos; // Use macOS config for your macOS platform
      case TargetPlatform.windows:
        return windows; // Use Windows config if needed
      default:
        throw UnsupportedError('DefaultFirebaseOptions are not supported for this platform.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAtVD9wj3oljZCYdQ9fsnCwuqbVJwUWvH4',
    appId: '1:32487550799:web:81349c8d1308c4126e5f3a',
    messagingSenderId: '32487550799',
    projectId: 'dailyplanner-583c0',
    authDomain: 'dailyplanner-583c0.firebaseapp.com',
    storageBucket: 'dailyplanner-583c0.appspot.com',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAtVD9wj3oljZCYdQ9fsnCwuqbVJwUWvH4',
    appId: '1:32487550799:web:81349c8d1308c4126e5f3a',
    messagingSenderId: '32487550799',
    projectId: 'dailyplanner-583c0',
    authDomain: 'dailyplanner-583c0.firebaseapp.com',
    storageBucket: 'dailyplanner-583c0.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAtVD9wj3oljZCYdQ9fsnCwuqbVJwUWvH4',
    appId: '1:32487550799:web:bc2cd3841912222e6e5f3a',
    messagingSenderId: '32487550799',
    projectId: 'dailyplanner-583c0',
    authDomain: 'dailyplanner-583c0.firebaseapp.com',
    storageBucket: 'dailyplanner-583c0.appspot.com',
  );
}
