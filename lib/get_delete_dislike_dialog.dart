import 'package:ShiCui/my_app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GetDeleteDislikeDialog extends StatefulWidget {
  
  GetDeleteDislikeDialog({
    super.key
  });

  @override
  State<GetDeleteDislikeDialog> createState() => _GetDeleteDislikeDialogState();
}

class _GetDeleteDislikeDialogState extends State<GetDeleteDislikeDialog> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var theme = Theme.of(context);

    return AlertDialog(
      backgroundColor: theme.colorScheme.primaryContainer, 
      title: Text(
        "确定要清空不喜欢的句子嘛???", 
        style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onPrimaryContainer, 
              fontWeight: FontWeight.bold,
            ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            setState(() {
              appState.deleteAllDislikePair();
            });
            Navigator.of(context).pop();
          }, 
          child: Text(
            "确定", 
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onPrimaryContainer, 
              fontWeight: FontWeight.bold,
            )
          ), 
        ), 
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        }, 
        child: Text(
          "取消", 
          style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onPrimaryContainer, 
                fontWeight: FontWeight.bold,
          )
        ), 
      )
      ],
    );
  }
}