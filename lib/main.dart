import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mumbojumbo/common/router.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

const spcolor = Color(0xffeb5f28);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: spcolor),
        elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: spcolor, 
          foregroundColor: Colors.white, 
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15), 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), 
          ),
        ),
      ),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}
