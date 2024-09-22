import 'package:ShiCui/my_app_state.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HistoryListView extends StatefulWidget {
  const HistoryListView({super.key});

  @override
  State<HistoryListView> createState() => _HistoryListViewState();
}

class _HistoryListViewState extends State<HistoryListView> {
  final _key = GlobalKey();
  Flushbar? historyPageFlushBar;

  static const Gradient _maskingGradient = LinearGradient(
    colors: [Colors.transparent, Colors.black], 
    begin: Alignment.topCenter, 
    end: Alignment.bottomCenter, 
    stops: [0.0, 0.5]);

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    appState.historyListKey = _key;
    
    var theme = Theme.of(context);
  

    return ShaderMask(
      shaderCallback:(bounds) {
      return _maskingGradient.createShader(bounds);
    },
      blendMode: BlendMode.dstIn,
      child: AnimatedList(
        key: _key,
        reverse: true, 
        padding: EdgeInsets.only(top: 100), 
        initialItemCount: appState.historyPair.length, 
        itemBuilder: (context, index, animation) {
          final pair = appState.historyPair[index];

          return SizeTransition(
            sizeFactor: animation, 
            child: Center(
              child: TextButton.icon(
                  onPressed: () {
                    appState.addFavoritePair(pair);
                  },
                  icon: appState.favoritePair.contains(pair)
                      ? Icon(Icons.favorite_rounded, size: 12,) 
                      : SizedBox(),
                  label: Padding(
                    padding: EdgeInsets.all(10), 
                    child: GestureDetector(
                      onLongPress: () {
                        Clipboard.setData(
                          ClipboardData(text: "${pair.content} \n" "   --${pair.author}")
                        );
                        historyPageFlushBar = Flushbar(
                          maxWidth: 300, 
                          messageText: Text(
                            "句子已复制到剪贴板", 
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer, 
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          backgroundColor: theme.colorScheme.primaryFixedDim, 
                          borderRadius: BorderRadius.all(Radius.circular(12.0)), 
                          boxShadows: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2), 
                              spreadRadius: 1, 
                              blurRadius: 5, 
                              offset: Offset(0, 2)
                            )
                          ],
                          margin: EdgeInsets.only(top: 15), 
                          duration: Duration(seconds: 1), 
                          flushbarPosition: FlushbarPosition.TOP, 
                          isDismissible: true,
                        );
                        historyPageFlushBar!.show(context);
                      },
                      child: Text(
                      "${pair.content} \n" "   --${pair.author}", 
                      style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold
                              ),
                    ),
                    )
                    ), 
                  ),
            ),
            
            );
        },
      ),
    );
  }
}