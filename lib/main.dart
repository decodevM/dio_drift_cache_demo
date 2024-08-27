import 'package:flutter/material.dart';

import 'api/api_service.dart';
import 'ui/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure widgets are initialized
  await ApiService.instance.init(); // Initialize ApiService
  runApp(const MyApp()); // Start the app
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Dio Cache Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(title: 'Flutter Dio Cache Demo Home Screen'),
    );
  }
}
