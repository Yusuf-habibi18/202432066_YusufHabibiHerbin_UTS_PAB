import 'package:flutter/material.dart';

import 'package:uts_pab/core/theme/app_theme.dart';
import 'package:uts_pab/features/home/home_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const HomeScreen(),
    );
  }
}
