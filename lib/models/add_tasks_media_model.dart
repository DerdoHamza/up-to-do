class AddTasksMediaModel {
  late String fileName;
  late int taskId;
  late String extension;
  late bool active;
  late String dateAdded;
  late String addedBy;
  late String dateUpdated;
  late String updatedBy;
  late String path;
  String snapshotUrl;
  AddTasksMediaModel({
    required this.fileName,
    required this.taskId,
    required this.extension,
    required this.active,
    required this.dateAdded,
    required this.addedBy,
    required this.dateUpdated,
    required this.updatedBy,
    required this.path,
    this.snapshotUrl = '',
  });
  Map<String, dynamic> toMap() => {
        'fileName': fileName,
        'taskId': taskId,
        'extension': extension,
        'active': active,
        'dateAdded': dateAdded,
        'addedBy': addedBy,
        'dateUpdated': dateUpdated,
        'updatedBy': updatedBy,
        'path': path,
        'snapshot_url': snapshotUrl,
      };
}
