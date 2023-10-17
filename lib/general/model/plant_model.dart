class Plants {
  final String id;
  final String name;
  final String scientificName;
  final String description;
  final Map<String, dynamic> characteristics;
  final Map<String, dynamic> plantingTips;
  final String gallery;
  final List<String> favorites;

  Plants({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.description,
    required this.characteristics,
    required this.plantingTips,
    required this.gallery,
    required this.favorites,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name' : name,
    'scientificName' : scientificName,
    'description' : description,
    'characteristics' : {},
    'plantingTips' : {},
    'gallery' : gallery,
    'favorites': [],
  };

}