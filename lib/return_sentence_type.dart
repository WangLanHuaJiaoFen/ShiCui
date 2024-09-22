class ReturnSentenceType {
  int? cartoon;
  int? comic;
  int? game;
  int? culture;
  int? movie;
  int? poetry;
  int? netease;
  int? philosophy;

  ReturnSentenceType({
    this.cartoon, 
    this.comic, 
    this.game, 
    this.culture, 
    this.movie, 
    this.poetry, 
    this.netease, 
    this.philosophy,
    });

    List<int?> _retList() {
      return [
        cartoon, 
        comic, 
        game, 
        culture, 
        movie, 
        poetry, 
        netease, 
        philosophy, 
      ];
    }

    String retRestUrl() {
      List<String> choice = ['a', 'b', 'c', 'd', 'h', 'i', 'j', 'k'];
      List<int?> judgeList = _retList();
      String retUrl = "";
      int alreadyHave = 0;
      for(int index = 0; index < judgeList.length; index++) {
        if (judgeList[index] != null && judgeList[index] == 1) {
          if (alreadyHave == 0) {
            // 第一次
            retUrl = "$retUrl?c=${choice[index]}";
            alreadyHave = 1;
          } else {
            retUrl = "$retUrl&c=${choice[index]}";
          }
        }
      }
      return retUrl;
    }
}
