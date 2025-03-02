import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:up_to_do/models/add_tasks_media_model.dart';
import 'package:up_to_do/models/get_task_model.dart';
import 'package:up_to_do/models/get_tasks_media_model.dart';
import 'package:up_to_do/models/get_team_model.dart';
import 'package:up_to_do/models/task_model.dart';
import 'package:up_to_do/models/user_model.dart';
import 'package:up_to_do/services/constant.dart';
import 'package:up_to_do/services/cubit/to_do_states.dart';

import '../../models/add_team_model.dart';

class ToDoCubit extends Cubit<ToDoStates> {
  ToDoCubit(super.initialState);
  static ToDoCubit get(context) => BlocProvider.of(context);
  bool loginVisibility = false;
  void changeLoginVisibility() {
    loginVisibility = !loginVisibility;
    emit(ToDoLoginVisibilityState());
  }

  bool signUpVisibility = false;
  void changeSignUpVisibility() {
    signUpVisibility = !signUpVisibility;
    emit(ToDoSignUpVisibilityState());
  }

  void signUp({
    required UserModel user,
  }) {
    emit(ToDoSignUpLoadingState());
    Supabase.instance.client.auth
        .signUp(
      email: user.email.toLowerCase().trim(),
      password: user.password.trim(),
      data: user.toMap(),
    )
        .then((value) {
      emit(ToDoSignUpSuccessState());
    }).catchError((error) {
      emit(ToDoSignUpErrorState(error.message.toString()));
    });
  }

  void logIn({
    required String email,
    required String password,
  }) {
    emit(ToDoLogInLoadingState());
    Supabase.instance.client.auth
        .signInWithPassword(
      email: email.toLowerCase().trim(),
      password: password.trim(),
    )
        .then((value) {
      emit(ToDoLogInSuccessState(value.user!.id));
    }).catchError((error) {
      emit(ToDoLogInErrorState(error.message.toString()));
    });
  }

  void signOut() {
    emit(ToDoSignOutLoadingState());
    Supabase.instance.client.auth.signOut().then((value) {
      emit(ToDoSignOutSuccessState());
    }).catchError((error) {
      emit(ToDoSignOutErrorState(error.message.toString()));
    });
  }

  void forgetPassword({
    required String email,
  }) {
    emit(ToDoForgetPasswordLoadingState());
    Supabase.instance.client.auth.resetPasswordForEmail(email).then((value) {
      emit(ToDoForgetPasswordSuccessState());
    }).catchError((error) {
      emit(ToDoForgetPasswordErrorState(error.toString()));
    });
  }

  List<GetTaskModel> allTasks = [];
  List<GetTaskModel> searchTasks = [];
  void getAllTasks() {
    allTasks = [];
    searchTasks = [];
    emit(ToDoGetAllTaskLoadingState());
    Supabase.instance.client
        .from('tasks')
        .select('*')
        .eq('userId', userId!)
        .eq('active', true)
        .then((value) {
      for (var element in value) {
        allTasks.add(GetTaskModel.fromJson(element));
        searchTasks.add(GetTaskModel.fromJson(element));
      }
      emit(ToDoGetAllTaskSuccessState());
    }).catchError((error) {
      log(error.toString());
      emit(ToDoGetAllTaskErrorState(error.toString()));
    });
  }

  void search({
    required String text,
  }) {
    emit(ToDoSearchLoadingState());
    if (text.isNotEmpty) {
      searchTasks = allTasks.where((element) {
        return (element.title
            .toLowerCase()
            .trim()
            .contains(text.toLowerCase().trim()));
      }).toList();
    } else {
      getAllTasks();
    }
    emit(ToDoSearchSuccessState());
  }

  void addTask({
    required TaskModel data,
  }) {
    emit(ToDoAddTaskLoadingState());
    Supabase.instance.client
        .from('tasks')
        .insert(
          data.toMap(),
        )
        .then((value) {
      getAllTasks();
    }).catchError((error) {
      emit(ToDoAddTaskErrorState(error.toString()));
    });
  }

  void editTask({
    required String title,
    required String description,
    required int id,
  }) {
    emit(ToDoEditTaskLoadingState());
    Supabase.instance.client
        .from('tasks')
        .update({
          'title': title,
          'description': description,
          'dateUpdated': DateTime.now().toIso8601String(),
          'updatedBy': userId,
        })
        .eq('id', id)
        .then((value) {
          getAllTasks();
        })
        .catchError((error) {
          emit(ToDoEditTaskErrorState(error.toString()));
        });
  }

  void deleteTask({
    required GetTaskModel data,
  }) {
    emit(ToDoDeleteTaskLoadingState());
    Supabase.instance.client
        .from('tasks')
        .update({
          'active': false,
          'dateUpdated': DateTime.now().toIso8601String(),
          'updatedBy': userId,
        })
        .eq(
          'id',
          data.id,
        )
        .then((value) {
          getAllTasks();
        })
        .catchError((error) {
          emit(ToDoDeleteTaskErrorState(error.toString()));
        });
  }

  DateTime? selectedDate;
  void taskDate({
    DateTime? date,
  }) {
    selectedDate = date;
    emit(ToDoTaskDateState());
  }

  void updateScheduled({
    required int id,
  }) {
    emit(ToDoUpdateScheduledLoadingState());
    Supabase.instance.client
        .from('tasks')
        .update({
          'scheduledNotification': selectedDate!.toIso8601String(),
          'updatedBy': userId,
          'dateUpdated': DateTime.now().toIso8601String(),
        })
        .eq('id', id)
        .then((value) {
          getAllTasks();
          emit(ToDoUpdateScheduledSuccessState());
        })
        .catchError((error) {
          ToDoUpdateScheduledErrorState(error.toString());
        });
  }

  void picFile({
    required int id,
  }) {
    emit(ToDoPicFileLoadingState());
    FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: [
        'jpeg',
        'jpg',
        'png',
        'pdf',
        'doc',
        'mp4',
        'avi',
        '3gp',
        'mkv',
      ],
    ).then((value) {
      if (value != null) {
        final file = File(value.files.first.path!);
        final fileName = value.files.first.name;
        AddTasksMediaModel media;
        Supabase.instance.client.storage
            .from('taskMedia')
            .upload(
              fileName,
              file,
            )
            .then((value) {
          final String url = Supabase.instance.client.storage
              .from('taskMedia')
              .getPublicUrl(fileName);
          final String extension = fileName.split('.').last;
          late String snapshotUrl;
          if (['mp4', 'avi', 'mkv'].contains(extension)) {
            VideoThumbnail.thumbnailData(
              video: url,
              imageFormat: ImageFormat.JPEG,
              maxWidth: 128,
              quality: 25,
            ).then((value) {
              Uint8List uint8list = value;
              Supabase.instance.client.storage
                  .from('taskMedia')
                  .uploadBinary(
                    'snapshot_$fileName',
                    uint8list,
                  )
                  .then((value) {
                snapshotUrl = Supabase.instance.client.storage
                    .from('taskMedia')
                    .getPublicUrl('snapshot_$fileName');

                media = AddTasksMediaModel(
                  fileName: fileName.split('.').first,
                  taskId: id,
                  extension: extension,
                  active: true,
                  dateAdded: DateTime.now().toIso8601String(),
                  addedBy: userId!,
                  dateUpdated: '',
                  updatedBy: userId!,
                  path: url,
                  snapshotUrl: snapshotUrl,
                );
                Supabase.instance.client
                    .from('tasks_media')
                    .insert(
                      media.toMap(),
                    )
                    .then((value) {
                  getTasksMedia(id: id);
                  emit(ToDoPicFileSuccessState());
                }).catchError((error) {
                  emit(ToDoPicFileErrorState(error.toString()));
                });
              });
            });
          } else {
            media = AddTasksMediaModel(
              fileName: fileName.split('.').first,
              taskId: id,
              extension: extension,
              active: true,
              dateAdded: DateTime.now().toIso8601String(),
              addedBy: userId!,
              dateUpdated: '',
              updatedBy: userId!,
              path: url,
              snapshotUrl: '',
            );
            Supabase.instance.client
                .from('tasks_media')
                .insert(
                  media.toMap(),
                )
                .then((value) {
              getTasksMedia(id: id);
              emit(ToDoPicFileSuccessState());
            }).catchError((error) {
              emit(ToDoPicFileErrorState(error.toString()));
            });
          }
        }).catchError((error) {
          log(error.toString());
          emit(ToDoPicFileErrorState(error.toString()));
        });
      }
    }).catchError((error) {
      log(error.toString());
      emit(ToDoPicFileErrorState(error.toString()));
    });
  }

  List<GetTasksMediaModel> tasksMedia = [];
  void getTasksMedia({
    required int id,
  }) {
    tasksMedia = [];
    emit(ToDoGetTasksMediLoadingState());
    Supabase.instance.client
        .from('tasks_media')
        .select('*')
        .eq('taskId', id)
        .eq('active', true)
        .then((value) {
      for (var element in value) {
        tasksMedia.add(GetTasksMediaModel.fromJson(element));
      }
      emit(ToDoGetTasksMediSuccessState());
    }).catchError((error) {
      emit(ToDoGetTasksMediErrorState(error.toString()));
    });
  }

  void deleteMediaFile({
    required int id,
    required int taskId,
  }) {
    emit(ToDoDeleteMediaFileLoadingState());
    Supabase.instance.client
        .from('tasks_media')
        .update({
          'active': false,
          'dateUpdated': DateTime.now().toIso8601String(),
          'updatedBy': userId,
        })
        .eq('id', id)
        .then((value) {
          emit(ToDoDeleteMediaFileSuccessState());
          getTasksMedia(id: taskId);
        })
        .catchError((error) {
          emit(ToDoDeleteMediaFileErrorState(error.toString()));
        });
  }

  void createTeam({
    required AddTeamModel team,
  }) {
    emit(ToDoCreatTeamLoadingState());
    Supabase.instance.client.from('teams').insert(team.toMap()).then((value) {
      getMyTeams();
      getMyJoinedTeam();
    }).catchError((error) {
      emit(ToDoCreatTeamErrorState(error.toString()));
    });
  }

  List<GetTeamModel> myTeams = [];
  void getMyTeams() {
    emit(ToDoGetMyTeamsLoadingState());
    Supabase.instance.client
        .from('teams')
        .select('*')
        .eq('leaderId', userId!)
        .eq('active', true)
        .then((value) {
      for (var element in value) {
        myTeams.add(GetTeamModel.fromJson(element));
      }
      emit(ToDoGetMyTeamsSuccessState());
    }).catchError((error) {
      emit(ToDoGetMyTeamsErrorState(error.toString()));
    });
  }

  void updateTeam({
    required int teamId,
    required GetTeamModel team,
  }) {
    emit(ToDoUpdateTeamLoadingState());
    team.dateUpdated = DateTime.now().toIso8601String();
    team.updatedBy = userId!;
    Supabase.instance.client
        .from('teams')
        .update(team.toMap())
        .eq('id', teamId)
        .eq('active', true)
        .then((value) {
      emit(ToDoUpdateTeamSuccessState());
    }).catchError((error) {
      emit(ToDoUpdateTeamErrorState(error.toString()));
    });
  }

  void removeTeam({
    required int teamId,
  }) {
    emit(ToDoDeleteTeamLoadingState());
    Supabase.instance.client
        .from('teams')
        .update(
          {
            'active': false,
            'dateUpdated': DateTime.now().toIso8601String(),
            'UpdatedBy': userId,
          },
        )
        .eq('id', teamId)
        .then((value) {
          emit(ToDoDeleteTeamSuccessState());
        })
        .catchError((error) {
          emit(ToDoDeleteTeamErrorState(error.toString()));
        });
  }

  GetTeamModel? team;
  void getTeam({
    required int teamId,
  }) {
    emit(ToDoGetTeamLoadingState());
    Supabase.instance.client
        .from('teams')
        .select('*')
        .eq('id', teamId)
        .then((value) {
      team = GetTeamModel.fromJson(value.first);
      emit(ToDoGetTeamSuccessState());
    }).catchError((error) {
      emit(ToDoGetTeamErrorState(error.toString()));
    });
  }

  List<int> teamIds = [];
  List<GetTeamModel> myJoinedTeam = [];
  void getMyJoinedTeam() {
    emit(ToDoGetMyJoinedTeamLoadingState());
    Supabase.instance.client
        .from('users_teams')
        .select('*')
        .eq('userId', userId!)
        .then((value) {
      for (var element in value) {
        teamIds.add(element['teamId']);
      }
      Supabase.instance.client
          .from('teams')
          .select('*')
          .inFilter('id', teamIds)
          .eq('active', true)
          .then((value) {
        for (var element in value) {
          myJoinedTeam.add(GetTeamModel.fromJson(element));
        }
        emit(ToDoGetMyJoinedTeamSuccessState());
      }).catchError((error) {
        emit(ToDoGetMyJoinedTeamErrorState(error.toString()));
      });
    }).catchError((error) {
      emit(ToDoGetMyJoinedTeamErrorState(error.toString()));
    });
  }

  void addTaskToTeam({
    required int teamId,
    required TaskModel task,
  }) {
    emit(ToDoAddTaskToTeamLoadingState());
    task.teamId = teamId;
    Supabase.instance.client.from('tasks').insert(task.toMap()).then((value) {
      emit(ToDoAddTaskToTeamSuccessState());
    }).catchError((error) {
      emit(ToDoAddTaskToTeamErrorState(error.toString()));
    });
  }

  List<GetTaskModel> teamTasks = [];
  void getTeamTasks({
    required int teamId,
  }) {
    emit(ToDoGetTeamTasksLoadingState());
    Supabase.instance.client
        .from('tasks')
        .select('*')
        .eq('teamId', teamId)
        .eq('active', true)
        .then((value) {
      for (var element in value) {
        teamTasks.add(GetTaskModel.fromJson(element));
      }
      emit(ToDoGetTeamTasksSuccessState());
    }).catchError((error) {
      emit(ToDoGetTeamTasksErrorState(error.toString()));
    });
  }

  void joinTeam({
    required int teamId,
  }) {
    emit(ToDoJoinTeamLoadingState());
    Supabase.instance.client
        .from('users_teams')
        .select()
        .eq('userId', userId!)
        .eq('teamId', teamId)
        .then((value) {
      if (value.isEmpty) {
        Supabase.instance.client.from('users_teams').insert({
          'userId': userId,
          'teamId': teamId,
        });
        emit(ToDoJoinTeamSuccessState());
      } else {
        emit(ToDoJoinTeamErrorState('you already joined this team !'));
      }
    }).catchError((error) {
      emit(ToDoJoinTeamErrorState(error.toString()));
    });
  }

  void leaveTeam({
    required int teamId,
  }) {
    emit(ToDoLeaveTeamLoadingState());
    Supabase.instance.client
        .from('users_teams')
        .select()
        .eq('userId', userId!)
        .eq('teamId', teamId)
        .then((value) {
      if (value.isNotEmpty) {
        Supabase.instance.client
            .from('users_teams')
            .delete()
            .eq('userId', userId!)
            .eq('teamId', teamId)
            .then((value) {
          emit(ToDoLeaveTeamSuccessState());
        }).catchError((error) {
          emit(ToDoLeaveTeamErrorState(error.toString()));
        });
      }
    }).catchError((error) {
      emit(ToDoLeaveTeamErrorState('You are not a member of this team !'));
    });
  }
}
