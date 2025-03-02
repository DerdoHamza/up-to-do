class AddTeamModel {
  late String title;
  late String description;
  late String leaderId;
  late bool active;
  late bool archived;
  String dateAdded = DateTime.now().toIso8601String();
  late String addedBy;

  AddTeamModel({
    required this.title,
    required this.description,
    required this.leaderId,
    this.active = true,
    this.archived = false,
    required this.addedBy,
  });

  Map<String, dynamic> toMap() => {
        'title': title,
        'description': description,
        'leaderId': leaderId,
        'active': active,
        'archived': archived,
        'dateAdded': dateAdded,
        'addedBy': addedBy,
      };
}
