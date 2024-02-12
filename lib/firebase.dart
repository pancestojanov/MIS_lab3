import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return android;
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDK_KoeqdtdrR55TugXL-Feqh37jSyWL_I',
    appId: '1:917764680296:android:e705d345fa54056e3229dd',
    messagingSenderId: '917764680296',
    projectId: 'flutter-firebase-3d27d',
    storageBucket: 'flutter-firebase-3d27d.appspot.com',
  );
}