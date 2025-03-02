class GetTaskModel {
  late int id;
  late String title;
  late String description;
  String scheduledNotification = '';
  bool active = true;
  bool archived = false;
  late String addedBy;
  String updatedBy = '';
  String dateAdded = DateTime.now().toIso8601String();
  String dateUpdated = '';
  late String userId;
  int? teamId;

  GetTaskModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    scheduledNotification = json['scheduledNotification'];
    active = json['active'];
    archived = json['archived'];
    addedBy = json['addedBy'];
    updatedBy = json['updatedBy'];
    dateAdded = json['dateAdded'];
    dateUpdated = json['dateUpdated'];
    userId = json['userId'];
    teamId = json['teamId'];
  }
  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'scheduledNotification': scheduledNotification,
        'active': active,
        'archived': archived,
        'addedBy': addedBy,
        'updatedBy': updatedBy,
        'dateAdded': dateAdded,
        'dateUpdated': dateUpdated,
        'userId': userId,
        'teamId': teamId,
      };
}
