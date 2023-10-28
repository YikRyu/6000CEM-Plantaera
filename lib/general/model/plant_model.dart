class Plants {
  final String id;
  final String name;
  final String scientificName;
  final String description;
  final String plantType;
  final String lifespan;
  final String bloomTime;
  final String habitat;
  final String difficulty;
  final String sunlight;
  final String soil;
  final String water;
  final String fertilize;
  final String plantingTime;
  final String harvestTime;
  final String disease;
  final String cover;
  final List<String> favorites;



  Plants({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.description,
    required this.plantType,
    required this.lifespan,
    required this.bloomTime,
    required this.habitat,
    required this.difficulty,
    required this.sunlight,
    required this.soil,
    required this.water,
    required this.fertilize,
    required this.plantingTime,
    required this.harvestTime,
    required this.disease,
    required this.cover,
    required this.favorites,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name' : name,
    'nameSmallCase' : name.toLowerCase(),
    'scientificName' : scientificName,
    'scientificSmallCase' : scientificName.toLowerCase(),
    'description' : description,
    'plantType' :plantType,
    'lifespan' : lifespan,
    'bloomTime' : bloomTime,
    'habitat' :habitat,
    'difficulty' :difficulty,
    'sunlight' : sunlight,
    'soil' : soil,
    'water' : water,
    'fertilize' :fertilize,
    'platingTime' : plantingTime,
    'harvestTime' : harvestTime,
    'disease' : disease,
    'cover' : cover,
    'favorites': [],
  };

}