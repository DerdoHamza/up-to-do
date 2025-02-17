class TaskModel {
  int? id;
  late String taskTitle;
  late String taskDecription;
  TaskModel({
    this.id,
    required this.taskTitle,
    required this.taskDecription,
  });
  TaskModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    taskTitle = json['taskTitle'];
    taskDecription = json['taskDecription'];
  }
  Map<String, dynamic> toMap() => {
        'id': id,
        'taskTitle': taskTitle,
        'taskDecription': taskDecription,
      };
}
