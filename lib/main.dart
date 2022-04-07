import 'dart:async';
import 'dart:io';


import 'package:GyroLocationApp/ui/my_app.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'di/components/service_locator.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await setPreferredOrientations();

  if (Platform.isIOS) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "your api key Found in GoogleService-info.plist",
            appId: "Your app id found in Firebase",
            messagingSenderId: "Your Sender id found in Firebase",
            projectId: "Your Project id found in Firebase"));
  } else {

    await Firebase.initializeApp();
    await FirebaseAppCheck.instance.activate(
      webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    );
    await _debugPlatform();
  }
  await setupLocator();
  return runZonedGuarded(() async {
    runApp(MyApp());
  }, (error, stack) {
    print(stack);
    print(error);
  });
}

  _debugPlatform() async{
  final appCheck = FirebaseAppCheck.instance;
  await appCheck.activate();
  await appCheck.getToken();
}

Future<void> setPreferredOrientations() {
  return SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
}
