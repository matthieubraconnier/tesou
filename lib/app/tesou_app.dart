import 'package:flutter/material.dart';
import 'package:tesou/app/theme/tesou_theme.dart';
import 'package:tesou/features/home/home_screen.dart';

class TesouApp extends StatelessWidget {
  const TesouApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'T’es où ? Je suis là !',
      debugShowCheckedModeBanner: false,
      theme: TesouTheme.light,
      home: const HomeScreen(),
    );
  }
}
