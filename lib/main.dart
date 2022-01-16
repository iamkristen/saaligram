import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saaligram/provider/user_provider.dart';
import 'package:saaligram/responsive/mobile_screen_layout.dart';
import 'package:saaligram/responsive/responsive_layout.dart';
import 'package:saaligram/responsive/web_screen_layout.dart';
import 'package:saaligram/screens/login_screen.dart';
import 'package:saaligram/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyAdRi4fhbaXpJ4ae7L0lB-CxGg6zk1s9bY",
            authDomain: "saaligram-71bf5.firebaseapp.com",
            appId: "1:638855490:web:25f57bcff59f5c4565c0db",
            messagingSenderId: "638855490",
            storageBucket: "saaligram-71bf5.appspot.com",
            measurementId: "G-ZZL2TP9K40",
            projectId: "saaligram-71bf5"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Saaligram',
        theme: ThemeData(
            appBarTheme: const AppBarTheme(backgroundColor: primaryColor),
            primarySwatch: swatchColor,
            primaryColor: primaryColor,
            iconTheme: const IconThemeData(
              color: primaryColor,
            )),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayout(
                    mobileScreenLayout: MobileScreenLayout(),
                    webScreenLayout: WebScreenLayout());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("${snapshot.error}"),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
