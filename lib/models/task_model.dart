class TaskModel {
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
  TaskModel({
    required this.title,
    required this.description,
    required this.userId,
    required this.addedBy,
  });
  TaskModel.fromJson(Map<String, dynamic> json) {
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
