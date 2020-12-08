import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:groupbuyapp/pages_and_widgets/piggybuy_root.dart';
import 'package:groupbuyapp/pages_and_widgets/splashscreen_widget.dart';
import 'locator.dart';

void enterApp() {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Phoenix(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        FirebaseFirestore.instance.settings = Settings(persistenceEnabled: false);
        //Check for errors
        if (snapshot.hasError) {
          print("firebase failed"); // TODO: pop up error about connection
          throw Exception("Error initialising Firebase");
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          print("firebase connected");

          return PiggyBuyApp();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        print("firebase loading"); // TODO: goto splash screen
        return SplashScreen(); // Loading();
      },
    );
  }
}
