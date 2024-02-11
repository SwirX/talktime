import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:talktime/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: appRoutes,
      initialRoute: "/",
    );
  }
}

void debugPrint(Object? object) {
  if (kDebugMode) {
    print(object);
  }
}
