class GetTeamModel {
  late int id;
  late String title;
  late String description;
  late String leaderId;
  late bool active;
  late bool archived;
  late String dateAdded;
  late String dateUpdated;
  late String addedBy;
  late String updatedBy;
  GetTeamModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    leaderId = json['leaderId'];
    active = json['active'];
    archived = json['archived'];
    dateAdded = json['dateAdded'];
    dateUpdated = json['dateUpdated'];
    addedBy = json['addedBy'];
    updatedBy = json['updatedBy'];
  }
  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'leaderId': leaderId,
        'active': active,
        'archived': archived,
        'dateAdded': dateAdded,
        'dateUpdated': dateUpdated,
        'addedBy': addedBy,
        'updatedBy': updatedBy,
      };
}
