class Diseases {
  final String id;
  final String title;
  final String content;
  final String banner;
  final List<String> favorites;

  Diseases({
    required this.id,
    required this.title,
    required this.content,
    required this.banner,
    required this.favorites,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title' : title,
    'content': content,
    'banner' : banner,
    'favorites': [],
  };

}