import 'dart:convert';
import 'package:ShiCui/return_sentence_type.dart';
import 'package:ShiCui/sentence.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyAppState extends ChangeNotifier{
  Flushbar? currentFlushbar;
  var type = {
    "动画": false,
    "漫画": false, 
    "游戏": false, 
    "文学": false, 
    "影视": false, 
    "诗词": false, 
    "网易云": false, 
    "哲学": false, 
  };
  var colorSeed = {
    "Blue": true, 
    "Pink": false, 
    "Cyan": false, 
    "Green": false, 
    "Indigo": false,
    "DeepOrange": false, 
    "DeepPurple": false, 
  };
  var currentSentence = Sentence(content: "Loading...", author: "Loading...", type: "Loading...");
  List<Sentence> historyPair = <Sentence>[];
  GlobalKey? historyListKey;
  int errorGetNextCounts = 0;
  late http.Response response;
  var favoritePair = <Sentence>[];
  List<Sentence> dislikePair = <Sentence>[];

  MyAppState() {
    initState();
  }

  Future<void> initState() async {
    await loadColorSetting();
    await loadTypeSetting();
    await loadFavorites();
    await loadDislikes();
    await getNext();
  }

  Future<void> getNext() async {
    Sentence tempSentence;
    bool needReget = false;
    ReturnSentenceType retType = ReturnSentenceType(
                cartoon: type["动画"] == true ? 1 : null, 
                comic: type["漫画"]  == true ? 1 : null, 
                game: type["游戏"]  == true ? 1 : null, 
                culture: type["文学"]  == true ? 1 : null, 
                movie: type["影视"]  == true ? 1 : null, 
                poetry: type["诗词"]  == true ? 1 : null, 
                netease: type["网易云"]  == true ? 1 : null, 
                philosophy:  type["哲学"]  == true ? 1 : null, 
              );
    do {
      needReget = false;
      var url;
      if (type.containsValue(true)) {
        url = Uri.parse("https://v1.hitokoto.cn${retType.retRestUrl()}");
      } else {
        url = Uri.parse("https://v1.hitokoto.cn?c=a&c=b&c=c&c=d&c=h&c=i&c=j&c=k");
      }

      response = await http.get(url);
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        tempSentence = Sentence(content: json['hitokoto'], author: json['from'], type: json['type']);
        print(url);
        if (favoritePair.contains(tempSentence) || historyPair.contains(tempSentence) || dislikePair.contains(tempSentence)) {
          needReget = true;
        } else if(currentSentence.content == "请求过快啦，稍微等一等吧" || dislikePair.contains(currentSentence)) {
          errorGetNextCounts = 0;
          currentSentence = tempSentence;
        } else {
          errorGetNextCounts = 0;
          if (currentSentence.content != "Loading...") {
            historyPair.insert(0, currentSentence);
            var animatedList = historyListKey?.currentState as AnimatedListState?;
            animatedList?.insertItem(0);
          }
          currentSentence = tempSentence;
          
        }
        
      } else {
        errorGetNextCounts = errorGetNextCounts == 0 ? 1 : 1;
        if (currentSentence.content != "请求过快啦，稍微等一等吧") {
          if (currentSentence.content != "Loading...") {
            historyPair.insert(0, currentSentence);
            var animatedList = historyListKey?.currentState as AnimatedListState?;
            animatedList?.insertItem(0);
          }
          currentSentence = Sentence(content: "请求过快啦，稍微等一等吧", author: "Waiting...", type: "Waiting...");
        }
      }
    } while (needReget);
  
    if (currentSentence.content != "Loading...") {
          notifyListeners();
    }
  }

  String getCurrentColorSeed() {
    return colorSeed.entries.firstWhere((entry) => entry.value).key;
  }
  
  void upDateColorSeed(String selectedColor) {
    colorSeed.updateAll((key, value) => key == selectedColor);
    notifyListeners();
  }
  
  void addFavoritePair([Sentence? pair]) {
    pair = pair ?? currentSentence;
    if (favoritePair.contains(pair)) {
      favoritePair.remove(pair);
    } else {
      favoritePair.add(pair);
    }
    saveFavorites();
    notifyListeners();
  }

  void deleteCurrentPair(Sentence current) {
    favoritePair.remove(current);
    saveFavorites();
    notifyListeners();
  }

  void addDislikePair() {
    if (dislikePair.contains(currentSentence)) {
      dislikePair.remove(currentSentence);
    } else {
      dislikePair.add(currentSentence);
    }
    saveDislikes();
    notifyListeners();
  }

  void deleteAllDislikePair() {
    dislikePair.clear();
    saveDislikes();
    notifyListeners();
  }

  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> encodedFavorites = favoritePair
      .map((pair) => jsonEncode({'content': pair.content, 'author': pair.author, 'type': pair.type}))
      .toList();
    await prefs.setStringList('favorites', encodedFavorites);
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? encodedFavorites = prefs.getStringList('favorites');
    if (encodedFavorites != null) {
      favoritePair = encodedFavorites
        .map((encodedPair) {
          Map<String, dynamic> jsonData = jsonDecode(encodedPair);
          return Sentence(content: jsonData['content'], author: jsonData['author'], type: jsonData['type']);
        })
        .toList();
        notifyListeners();
    }
  }
  
  Future<void> saveDislikes() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> encodedDislikes = dislikePair
      .map((pair) => jsonEncode({'content': pair.content, 'author': pair.author, 'type': pair.type}))
      .toList();
    await prefs.setStringList('dislikes', encodedDislikes);
  }

  Future<void> loadDislikes() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? encodedDislikes = prefs.getStringList('dislikes');
    if (encodedDislikes != null) {
      dislikePair = encodedDislikes
        .map((encodedPair) {
          Map<String, dynamic> jsonData = jsonDecode(encodedPair);
          return Sentence(content: jsonData['content'], author: jsonData['author'], type: jsonData['type']);
        }).toList();
        notifyListeners();
    }
  }

  Future<void> saveTypeSetting() async {
    final prefs = await SharedPreferences.getInstance();
    type.forEach((key, value) async {
      await prefs.setBool(key, value);
    });
  }

  Future<void> loadTypeSetting() async {
    final prefs = await SharedPreferences.getInstance();
    for (var key in type.keys) {
      type[key] = prefs.getBool(key) ?? false;
    }
    notifyListeners();
  }

  Future<void> saveColorSetting() async {
    final prefs = await SharedPreferences.getInstance();
    colorSeed.forEach((key, value) async {
      await prefs.setBool(key, value);
    });
  }

  Future<void> loadColorSetting() async {
    final prefs = await SharedPreferences.getInstance();
    int judge = 0;
    for (var key in colorSeed.keys) {
      colorSeed[key] = prefs.getBool(key) ?? false;
      if (colorSeed[key] == true) {
        judge = 1;
      }
    }
    if (judge == 0) {
      colorSeed['Blue'] = true;
    }
    notifyListeners();
  }
}
