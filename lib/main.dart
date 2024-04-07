import 'package:etherNotes/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:etherNotes/homeScreen.dart';
import 'package:etherNotes/web3client.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => NotesServices(),
      child: MaterialApp(
        title: 'etherNotes',
        theme: ThemeData(
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(), // Show splash screen initially
      ),
    ),
  );

  // Delay for 2 seconds and then navigate to HomeScreen
  Future.delayed(Duration(seconds: 3), () {
    runApp(
      ChangeNotifierProvider(
        create: (context) => NotesServices(),
        child: MaterialApp(
          title: 'etherNotes',
          theme: ThemeData(
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
          home: const HomeScreen(), // Navigate to HomeScreen after delay
        ),
      ),
    );
  });
}
