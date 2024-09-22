import 'package:flutter/material.dart';

class GetSettingCard extends StatelessWidget {
  final String titleText;
  final String settingText;
  final Widget Function(BuildContext) builderInitial;
  
  GetSettingCard({
    required this.titleText, 
    required this.settingText, 
    required this.builderInitial});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context); 

    return FractionallySizedBox(
      widthFactor: 0.8,
      child: Card(
        color: theme.colorScheme.primaryFixedDim, 
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0), 
              child: Text(
                titleText, 
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer, 
                  fontWeight: FontWeight.bold
            ), ),
              ), 
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    settingText, 
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer, 
                      fontWeight: FontWeight.bold
            ), ),
                  trailing: Icon(Icons.navigate_next_rounded), 
                  onTap: () {
                    showDialog(
                      context: context, 
                      barrierDismissible: true, 
                      builder: builderInitial
                      );
                  },
                ),
              )
          ],
        )
      ),
    );
  }
}
