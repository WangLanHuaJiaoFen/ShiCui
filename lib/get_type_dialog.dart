import 'package:ShiCui/my_app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GetTypeDialog extends StatefulWidget {

  GetTypeDialog({
    super.key
  });
  
  
  @override
  State<GetTypeDialog> createState() => _GetTypeDialogState();
}

class _GetTypeDialogState extends State<GetTypeDialog> {

  late Map<String, bool> localType;

  @override
  void initState() {
    super.initState();
    var appState = context.read<MyAppState>();
    localType = Map<String, bool>.from(appState.type);
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var theme = Theme.of(context);

    return AlertDialog(
      backgroundColor: theme.colorScheme.primaryContainer,
      title: Text(
        "请选择(全否默认随机)", 
        style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onPrimaryContainer, 
              fontWeight: FontWeight.bold
            ), 
      ), 
      content: Column(
        mainAxisSize: MainAxisSize.min, 
        children: localType.keys.map((String key) {
          return CheckboxListTile(
            
            title: Text(
              key, 
              style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onPrimaryContainer, 
              fontWeight: FontWeight.bold
            ), 
            ),
            value: localType[key],  
            onChanged: (bool? value) {
              setState(() {
                localType[key] = value!;
              });
            }, 
            );
        }, 
        ).toList(), 
      ), 
      actions: <Widget>[
        TextButton(
          onPressed: () {
            setState(() {
              appState.type = Map<String, bool>.from(localType);
              appState.saveTypeSetting();
            });
              Navigator.of(context).pop();
          }, 
          child: Text(
            "选好啦", 
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onPrimaryContainer, 
              fontWeight: FontWeight.bold
            ), )
          ), 
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            }, 
            child: Text(
              "取消", 
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onPrimaryContainer, 
                fontWeight: FontWeight.bold
            ), )
            ),
      ],
    );
  }
}
