class GetTasksMediaModel {
  late int id;
  late String fileName;
  late int taskId;
  late String extension;
  late bool active;
  late String dateAdded;
  late String addedBy;
  late String dateUpdated;
  late String updatedBy;
  late String path;
  late String snapshotUrl;
  GetTasksMediaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fileName = json['fileName'];
    taskId = json['taskId'];
    extension = json['extension'];
    active = json['active'];
    dateAdded = json['dateAdded'];
    addedBy = json['addedBy'];
    dateUpdated = json['dateUpdated'];
    updatedBy = json['updatedBy'];
    path = json['path'];
    snapshotUrl = json['snapshot_url'];
  }
  Map<String, dynamic> toMap() => {
        'extension': extension,
        'active': active,
        'dateAdded': dateAdded,
        'addedBy': addedBy,
        'dateUpdated': dateUpdated,
        'updatedBy': updatedBy,
        'path': path,
      };
}
