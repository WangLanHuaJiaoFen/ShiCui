import 'package:ShiCui/get_color_dialog.dart';
import 'package:ShiCui/get_delete_dislike_dialog.dart';
import 'package:ShiCui/get_setting_card.dart';
import 'package:ShiCui/get_type_dialog.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  var theme = Theme.of(context);
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.all(20), 
          child: Text(
            "Settings:", 
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onPrimaryContainer, 
              fontWeight: FontWeight.bold
            ), 
          ),
        ), 
        GetSettingCard(
          titleText: "清空", 
          settingText: "清空不喜欢", 
          builderInitial: (context) => GetDeleteDislikeDialog()), 
        Padding(padding: EdgeInsets.all(8.0)), 
        GetSettingCard(
          titleText: "类型设置", 
          settingText: "句子获取类型选择", 
          builderInitial: (context) => GetTypeDialog()),
        Padding(padding: EdgeInsets.all(8.0)), 
        GetSettingCard(
        titleText: "主题设置", 
        settingText: "主题颜色选择", 
        builderInitial: (context) => GetColorDialog()),
      ],
    );
  }
}
