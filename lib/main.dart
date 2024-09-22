import 'package:ShiCui/my_app.dart';
import 'package:ShiCui/my_app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => MyAppState(), 
    child: MyApp(),));
}
