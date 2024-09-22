import 'package:ShiCui/sentence.dart';
import 'package:flutter/material.dart';

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final Sentence pair;
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.headlineSmall!.copyWith(
      color: theme.colorScheme.onPrimary
    );
    
    return Card(
      
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: AnimatedSize(
          duration: Duration(milliseconds: 200), 
          child: Text(
                    "${pair.content} \n" "   --${pair.author}", 
                    style: style, 
                    ),
                  ),
      ),
    );
  }
}
