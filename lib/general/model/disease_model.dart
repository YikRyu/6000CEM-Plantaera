class Diseases {
  final String id;
  final String name;
  final String symptoms;
  final String cause;
  final String solutions;
  final String preventions;
  final String cover;
  final List<String> favorites;

  Diseases({
    required this.id,
    required this.name,
    required this.symptoms,
    required this.cause,
    required this.solutions,
    required this.preventions,
    required this.cover,
    required this.favorites,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name' : name,
    'nameSmallCase' : name.toLowerCase(),
    'symptoms': symptoms,
    'cause' : cause,
    'solutions' : solutions,
    'preventions' : preventions,
    'cover' : cover,
    'favorites': [],
  };

}