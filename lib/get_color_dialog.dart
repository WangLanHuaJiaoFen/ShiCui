import 'package:ShiCui/my_app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GetColorDialog extends StatefulWidget {
  GetColorDialog({
    super.key
  });

  @override
  State<GetColorDialog> createState() => _GetColorDialogState();
}

class _GetColorDialogState extends State<GetColorDialog> {
  late String? _selectedValue;

  @override
  void initState() {
    super.initState();
    var appState = context.read<MyAppState>();
    _selectedValue = appState.getCurrentColorSeed();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var theme = Theme.of(context);

    return AlertDialog(
      backgroundColor: theme.colorScheme.primaryContainer, 
      title: Text(
        "请选择(默认为blue)", 
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onPrimaryContainer, 
          fontWeight: FontWeight.bold
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min, 
        children: appState.colorSeed.keys.map((String key) {
          return RadioListTile(
            title: Text(
              key,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onPrimaryContainer, 
                fontWeight: FontWeight.bold
              ),
            ),
            value: key, 
            groupValue: _selectedValue, 
            onChanged: (String? value) {
              setState(() {
                _selectedValue = value;
              });
            });
        }).toList(),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            setState(() {
              appState.upDateColorSeed(_selectedValue!);
              //ToDo: 
              appState.saveColorSetting();
            });
            print(appState.colorSeed);
            Navigator.of(context).pop();
          }, 
          child: Text(
              "选好啦", 
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onPrimaryContainer, 
                fontWeight: FontWeight.bold
            ),
          )), 
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            }, 
            child: Text(
              "取消", 
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onPrimaryContainer, 
                fontWeight: FontWeight.bold
              ),
            ))
      ],
    );
  }
}
