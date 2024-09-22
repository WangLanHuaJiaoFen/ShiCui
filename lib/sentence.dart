class Sentence {
  final String content;
  final String author;
  final String type;

  const Sentence({required this.content, required this.author, required this.type});

  factory Sentence.fromJson(Map<String, dynamic> json) {
    return Sentence(
      content: json['hitokoto'] ?? "error", 
      author: json['from'] ?? "error", 
      type: json['type'] ?? "error"
      );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Sentence) return false;
    return content == other.content && author == other.author && type == other.type;
  }

}
