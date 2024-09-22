import 'package:ShiCui/my_app_state.dart';
import 'package:ShiCui/sentence.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatefulWidget {
  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  Map<String, bool> _pressedState = {};
  Flushbar? favoritesPageFlushBar;
  Map<String, String> corresponding = {
    'a': "动画", 
    'b': "漫画", 
    'c': "游戏", 
    'd': "文学", 
    'h': "影视", 
    'i': "诗词", 
    'j': "网易云", 
    'k': "哲学", 
  };

  Map<String, List<Sentence>> categorizeSentences(List<Sentence> sentences) {
    Map<String, List<Sentence>> categorized = {};

    for (var sentence in sentences) {
      if (categorized[sentence.type] == null) {
        categorized[sentence.type] = [];
      }
      categorized[sentence.type]!.add(sentence);
    }
    return categorized;
  }


  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var theme = Theme.of(context);
    

    if (appState.favoritePair.isEmpty) {
      return Center(
        child: Text("No favorites now!!!"),
      );
    } else {
      var categorizedSentences = categorizeSentences(appState.favoritePair);

      return ListView(
        children: categorizedSentences.keys.map((String type) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
              Padding(
                padding: const EdgeInsets.all(20), 
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "U have ${categorizedSentences[type]!.length} favorites: ", 
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer, 
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ), 
                    Text(
                      corresponding[type]!, 
                      style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer, 
                          fontWeight: FontWeight.bold
                        ),
                    )
                  ],
                ),
                ), 
                for (var pair in categorizedSentences[type]!.reversed) 
                  ListTile(
                    leading: IconButton(
                      onPressed: () {
                        appState.deleteCurrentPair(pair);
                      }, 
                      icon: Icon(
                        Icons.delete_outline_rounded, 
                        semanticLabel: "Delete",), 
                      color: theme.colorScheme.primary,),
                    title: GestureDetector(
                      onLongPress:() {
                        setState(() {
                          _pressedState[pair.content] = true;
                        });

                        Clipboard.setData(
                          ClipboardData(text: "${pair.content} \n" "   --${pair.author}"));
                          
                        favoritesPageFlushBar = Flushbar(
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
                              offset: Offset(0, 2), 
                            )
                          ],
                          margin: EdgeInsets.only(top: 15), 
                          duration: Duration(seconds: 1), 
                          isDismissible: true, 
                          flushbarPosition: FlushbarPosition.TOP,
                        );
                        
                        favoritesPageFlushBar!.show(context).then((_) {
                          Future.delayed(Duration(milliseconds: 200), () {
                            setState(() {
                              _pressedState[pair.content] = false;
                            });
                          });
                        });
                      },
                      onLongPressUp:() {
                        setState(() {
                          _pressedState[pair.content] = false;
                        });
                      },

                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        color: _pressedState[pair.content] == true
                            ? theme.colorScheme.primaryFixedDim
                            : theme.colorScheme.primaryContainer,
                        child: Text(
                                    "${pair.content} \n" "   --${pair.author}", 
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: theme.colorScheme.onPrimaryContainer, 
                                      fontWeight: FontWeight.bold
                                    ),
                                    ),
                      ),
                    )
                  )
            ],
          );
        }).toList()
      );
    }
  }
}

// [
//           Padding(
//             padding: const EdgeInsets.all(20), 
//             child: Text(
//               "U have ${appState.favoritePair.length} favorites: ", 
//               style: theme.textTheme.bodyLarge?.copyWith(
//                               color: theme.colorScheme.onPrimaryContainer, 
//                               fontWeight: FontWeight.bold
//                             ),),
//             ), 
//             for (var pair in appState.favoritePair.reversed) 
//               ListTile(
//                 leading: IconButton(
//                   onPressed: () {
//                     appState.deleteCurrentPair(pair);
//                   }, 
//                   icon: Icon(
//                     Icons.delete_outline_rounded, 
//                     semanticLabel: "Delete",), 
//                   color: theme.colorScheme.primary,),
//                 title: GestureDetector(
//                   onLongPress:() {
//                     setState(() {
//                       _pressedState[pair.content] = true;
//                     });

//                     Clipboard.setData(
//                       ClipboardData(text: "${pair.content} \n" "   --${pair.author}"));
                      
//                     favoritesPageFlushBar = Flushbar(
//                       maxWidth: 300, 
//                       messageText: Text(
//                         "句子已复制到剪贴板", 
//                         style: theme.textTheme.bodyLarge?.copyWith(
//                           color: theme.colorScheme.onPrimaryContainer, 
//                           fontWeight: FontWeight.bold
//                         ),
//                       ),
//                       backgroundColor: theme.colorScheme.primaryFixedDim, 
//                       borderRadius: BorderRadius.all(Radius.circular(12.0)), 
//                       boxShadows: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.2), 
//                           spreadRadius: 1, 
//                           blurRadius: 5, 
//                           offset: Offset(0, 2), 
//                         )
//                       ],
//                       margin: EdgeInsets.only(top: 15), 
//                       duration: Duration(seconds: 1), 
//                       isDismissible: true, 
//                       flushbarPosition: FlushbarPosition.TOP,
//                     );
                    
//                     favoritesPageFlushBar!.show(context).then((_) {
//                       Future.delayed(Duration(milliseconds: 200), () {
//                         setState(() {
//                           _pressedState[pair.content] = false;
//                         });
//                       });
//                     });
//                   },
//                   onLongPressUp:() {
//                     setState(() {
//                       _pressedState[pair.content] = false;
//                     });
//                   },

//                   child: AnimatedContainer(
//                     duration: Duration(milliseconds: 500),
//                     curve: Curves.easeInOut,
//                     color: _pressedState[pair.content] == true
//                         ? theme.colorScheme.primaryFixedDim
//                         : theme.colorScheme.primaryContainer,
//                     child: Text(
//                                 "${pair.content} \n" "   --${pair.author}", 
//                                 style: theme.textTheme.bodyLarge?.copyWith(
//                                   color: theme.colorScheme.onPrimaryContainer, 
//                                   fontWeight: FontWeight.bold
//                                 ),
//                                 ),
//                   ),
//                 )
//               )
//         ],