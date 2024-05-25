class Location {
  final String name;
  final String? parentId;
  final String id;

  Location({required this.name, this.parentId, required this.id});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'],
      parentId: json['parentId'],
      id: json['id'],
    );
  }
}
