import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyCrZFkElcky3_ZwrscjhNXJNCJ4ng_bvLI",
            authDomain: "price-action-master-2023.firebaseapp.com",
            projectId: "price-action-master-2023",
            storageBucket: "price-action-master-2023.appspot.com",
            messagingSenderId: "889699580291",
            appId: "1:889699580291:web:4529883aefa1e2455fdeb6",
            measurementId: "G-JVLZL2FN80"));
  } else {
    await Firebase.initializeApp();
  }
}
