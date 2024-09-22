import 'package:ShiCui/big_card.dart';
import 'package:ShiCui/history_list_view.dart';
import 'package:ShiCui/my_app_state.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class GeneratorPage extends StatefulWidget {

  @override
  State<GeneratorPage> createState() => _GeneratorPageState();
}

class _GeneratorPageState extends State<GeneratorPage> {
  Flushbar? generatorPageCopyFlushBar;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var sentence = appState.currentSentence;
    var theme = Theme.of(context);

    IconData likeIcon;
    IconData dislikeIcon;
    if (appState.favoritePair.contains(sentence)) {
      likeIcon = Icons.favorite_rounded;
    } else {
      likeIcon = Icons.favorite_border_rounded;
    }
    if(appState.dislikePair.contains(sentence)) {
      dislikeIcon = Icons.thumb_down_rounded;
    } else {
      dislikeIcon = Icons.thumb_down_off_alt_rounded;
    }

    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: HistoryListView(),
            ), 
            GestureDetector(
              onLongPress:() {
                Clipboard.setData(
                  ClipboardData(text: "${sentence.content} \n" "   --${sentence.author}")
                );
                generatorPageCopyFlushBar = Flushbar(
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
                generatorPageCopyFlushBar!.show(context);
              },
              child: BigCard(pair: sentence),
            ), 
            SizedBox(height: 10,), 
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    if (appState.currentSentence.content != "请求过快啦，稍微等一等吧") {
                      appState.addDislikePair();
                    }
                  }, 
                  icon: Icon(dislikeIcon),
                  label: Text("Dislike")
                  ),
                SizedBox(width: 10,), 
                ElevatedButton.icon(
                  onPressed: () {
                    if (appState.currentSentence.content != "请求过快啦，稍微等一等吧") {
                      appState.addFavoritePair();
                    }
                }, 
                icon: Icon(likeIcon),
                label: Text("Like it!!!"),
                ), 
                SizedBox(width: 10,), 
                ElevatedButton(
                  onPressed: () async { 
                    
                    await appState.getNext();
                    if (appState.currentSentence.content == "请求过快啦，稍微等一等吧" 
                    && appState.errorGetNextCounts == 1 
                    && (appState.currentFlushbar == null 
                    || appState.currentFlushbar!.isDismissed() == true)) {
                      appState.currentFlushbar = Flushbar(
                        maxWidth: 300,
                        messageText: Text(
                          "喝杯水再来看下一条叭...", 
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Theme.of(context).colorScheme.onPrimaryContainer, 
                                  fontWeight: FontWeight.bold
                                ),), 
                        backgroundColor: Theme.of(context).colorScheme.primaryFixedDim, 
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        boxShadows: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 2), 
                          ),
                        ],
                        margin: EdgeInsets.only(top: 15),
                        duration: Duration(seconds: 1), 
                        flushbarPosition: FlushbarPosition.TOP,
                        isDismissible: true,
                      );
                      appState.currentFlushbar!.show(context);
                    }
                  },
                  child: Text('Next'),
                ), 
                
              ],
            ),
            Spacer(flex: 2,)
          ],
        )
      );
  }
}
