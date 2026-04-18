import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'SplashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Tumbadi App",
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Georgia',
        textTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'Georgia',
          bodyColor: const Color(0xFF211E1B),
          displayColor: const Color(0xFF211E1B),
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      home: SplashScreen(),
    ),
  );
}
