import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:up_to_do/models/get_task_model.dart';
import 'package:up_to_do/services/cubit/to_do_cubit.dart';
import 'package:up_to_do/services/notification_service.dart';

void navigateTo({
  required BuildContext context,
  required Widget screen,
}) =>
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );
void navigateAndReplace({
  required BuildContext context,
  required Widget screen,
}) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
      (route) => false,
    );

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.prefix,
    required this.type,
    this.sufix,
    this.lines = 1,
    this.isvisible = false,
  });

  final TextEditingController controller;
  final String label;
  final Widget prefix;
  final TextInputType type;
  final int lines;
  final bool isvisible;
  final Widget? sufix;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value!.isEmpty) {
          return 'please enter $label';
        }
        return null;
      },
      keyboardType: type,
      minLines: 1,
      maxLines: lines,
      obscureText: isvisible,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        labelText: label,
        prefixIcon: prefix,
        suffixIcon: sufix,
        contentPadding: EdgeInsets.all(10),
        isDense: true,
      ),
    );
  }
}

class TaskItem extends StatelessWidget {
  TaskItem({
    super.key,
    required this.cubit,
    required this.task,
    required this.edit,
    required this.remove,
  });
  final GetTaskModel task;
  final ToDoCubit cubit;
  final VoidCallback edit;
  final VoidCallback remove;
  final TextEditingController dateController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Colors.blueGrey.withValues(alpha: 0.6),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  task.title,
                  style: GoogleFonts.adamina(
                    fontSize: 18,
                    color: Colors.cyan,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                IconButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          'Choose a time for yor reminder',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: dateController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please select Date & Time';
                                  }
                                  return null;
                                },
                                readOnly: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  labelText: 'Date & Time',
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(10),
                                ),
                                onTap: () {
                                  showDatePicker(
                                    context: context,
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now().add(
                                      Duration(days: 365),
                                    ),
                                  ).then((valueDate) {
                                    if (context.mounted) {
                                      if (valueDate != null) {
                                        showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now())
                                            .then((valueTime) {
                                          if (valueTime != null) {
                                            valueDate = valueDate!.copyWith(
                                              hour: valueTime.hour,
                                              minute: valueTime.minute,
                                            );
                                            cubit.taskDate(date: valueDate!);
                                            dateController.text =
                                                valueDate.toString();
                                          }
                                        });
                                      }
                                    }
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                        actionsAlignment: MainAxisAlignment.spaceBetween,
                        actions: [
                          TextButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                cubit.updateScheduled(
                                  id: task.id,
                                );
                                NotificationService.showNotification(
                                  date: cubit.selectedDate!,
                                  title: task.title,
                                  body: task.description,
                                  id: task.id,
                                );
                                Navigator.pop(context);
                              }
                            },
                            child: Text('Schedule'),
                          ),
                          TextButton(
                            onPressed: () {
                              cubit.taskDate();
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: Icon(Icons.alarm_add_outlined),
                ),
              ],
            ),

            Row(
              children: [
                Icon(Icons.alarm_add_outlined),
                SizedBox(width: 10),
                Text(
                  task.scheduledNotification,
                  style: TextStyle(
                    height: 0.4,
                  ),
                ),
              ],
            ),
            // SizedBox(height: 5),
            CustomDivider(),
            Text(
              task.description,
              style: GoogleFonts.adamina(
                fontSize: 16,
              ),
            ),
            CustomDivider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: edit,
                    child: Text(
                      'Edit',
                      style: GoogleFonts.adamina(
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: remove,
                    child: Text(
                      'Remove',
                      style: GoogleFonts.adamina(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Divider(
        color: Colors.black,
        endIndent: 8,
        indent: 8,
        thickness: 0.8,
      ),
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  final Color color;
  final VoidCallback onPress;
  final String text;
  final double width;

  const CustomElevatedButton({
    super.key,
    required this.color,
    required this.onPress,
    required this.text,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: color,
        elevation: 5,
        minimumSize: Size(width, 40),
      ),
      onPressed: onPress,
      child: Text(
        text,
        style: GoogleFonts.besley(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

Future<bool?> showToast({
  required String msg,
  required Color backgroundColor,
}) =>
    Fluttertoast.showToast(
      msg: msg,
      fontSize: 16,
      backgroundColor: backgroundColor,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_LONG,
      textColor: Colors.white,
    );
