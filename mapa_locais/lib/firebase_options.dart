import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

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
        throw UnsupportedError('Não há suporte para esta plataforma.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'demo-web-api-key',
    appId: '1:000000000000:web:demo',
    messagingSenderId: '000000000000',
    projectId: 'mapa-locais-demo',
    authDomain: 'mapa-locais-demo.firebaseapp.com',
    storageBucket: 'mapa-locais-demo.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'demo-android-api-key',
    appId: '1:000000000000:android:demo',
    messagingSenderId: '000000000000',
    projectId: 'mapa-locais-demo',
    storageBucket: 'mapa-locais-demo.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'demo-ios-api-key',
    appId: '1:000000000000:ios:demo',
    messagingSenderId: '000000000000',
    projectId: 'mapa-locais-demo',
    storageBucket: 'mapa-locais-demo.appspot.com',
    iosBundleId: 'com.example.mapaLocais',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'demo-macos-api-key',
    appId: '1:000000000000:macos:demo',
    messagingSenderId: '000000000000',
    projectId: 'mapa-locais-demo',
    storageBucket: 'mapa-locais-demo.appspot.com',
    iosBundleId: 'com.example.mapaLocais',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'demo-windows-api-key',
    appId: '1:000000000000:windows:demo',
    messagingSenderId: '000000000000',
    projectId: 'mapa-locais-demo',
    storageBucket: 'mapa-locais-demo.appspot.com',
    authDomain: 'mapa-locais-demo.firebaseapp.com',
  );
}
