import 'package:ShiCui/my_app_state.dart';
import 'package:ShiCui/my_home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  late final String colorSeedText;

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    String colorSeedText = appState.getCurrentColorSeed();

    // 根据 colorSeedText 动态设置颜色
    Color localSeedColor;
    switch (colorSeedText) {
      case "Blue":
        localSeedColor = Colors.blue.shade200;
        break;
      case "Pink":
        localSeedColor = Colors.pink;
        break;
      case "Cyan":
        localSeedColor = Colors.cyan;
        break;
      case "DeepOrange":
        localSeedColor = Colors.deepOrange;
        break;
      case "DeepPurple":
        localSeedColor = Colors.deepPurple;
        break;
      case "Green":
        localSeedColor = Colors.green;
        break;
      case "Indigo":
        localSeedColor = Colors.indigo;
        break;
      default:
        localSeedColor = Colors.blue.shade200; // 默认颜色
        break;
    }
    return MaterialApp(
        title: 'ShiCui',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: localSeedColor),
        ),
        home: MyHomePage(),
      );
  }
}
