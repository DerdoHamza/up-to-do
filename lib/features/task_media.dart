import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:up_to_do/features/pdf_viewer.dart';
import 'package:up_to_do/features/photo_viewer.dart';
import 'package:up_to_do/features/video_player.dart';
import 'package:up_to_do/models/get_tasks_media_model.dart';
import 'package:up_to_do/services/component.dart';
import 'package:up_to_do/services/cubit/to_do_cubit.dart';
import 'package:up_to_do/services/cubit/to_do_states.dart';

class TaskMedia extends StatelessWidget {
  final int id;
  const TaskMedia({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit, ToDoStates>(
      listener: (context, state) {
        if (state is ToDoDeleteMediaFileSuccessState) {
          showToast(
            msg: 'Task deleted successfully',
            backgroundColor: Colors.green,
          );
        }
        if (state is ToDoDeleteMediaFileErrorState) {
          showToast(
            msg: state.error,
            backgroundColor: Colors.red,
          );
        }
        if (state is ToDoPicFileErrorState) {
          showToast(
            msg: state.error,
            backgroundColor: Colors.red,
          );
        }
        if (state is ToDoPicFileSuccessState) {
          showToast(
            msg: 'File added successfully',
            backgroundColor: Colors.green,
          );
        }
      },
      builder: (context, state) {
        var cubit = ToDoCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('Media'),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(
                bottom: kBottomNavigationBarHeight * 1.25),
            child: FloatingActionButton(
              onPressed: () {
                cubit.picFile(id: id);
              },
              child: Icon(Icons.add),
            ),
          ),
          body: state is ToDoPicFileLoadingState ||
                  state is ToDoGetTasksMediLoadingState
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 8, left: 8, top: 8, bottom: 150),
                    child: Column(
                      mainAxisAlignment: cubit.tasksMedia.isEmpty
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.start,
                      children: [
                        cubit.tasksMedia.isEmpty
                            ? Text('No Tasks Media')
                            : Expanded(
                                child: ListView.separated(
                                  itemBuilder: (context, index) => MediaItem(
                                    media: cubit.tasksMedia[index],
                                    cubit: cubit,
                                    taskId: id,
                                  ),
                                  separatorBuilder: (context, index) =>
                                      SizedBox(height: 10),
                                  itemCount: cubit.tasksMedia.length,
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}

class MediaItem extends StatelessWidget {
  const MediaItem({
    super.key,
    required this.media,
    required this.cubit,
    required this.taskId,
  });
  final GetTasksMediaModel media;
  final ToDoCubit cubit;
  final int taskId;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (['jpeg', 'jpg', 'png'].contains(media.extension)) {
          navigateTo(
            context: context,
            screen: PhotoViewer(url: media.path),
          );
        } else if (['mp4', 'avi', 'mkv'].contains(media.extension)) {
          navigateTo(
            context: context,
            screen: VideoPlayers(url: media.path),
          );
        } else if (['pdf'].contains(media.extension)) {
          navigateTo(
            context: context,
            screen: PdfViwer(url: media.path),
          );
        }
      },
      child: Card(
        elevation: 5,
        color: Colors.blueGrey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    media.fileName,
                    style: GoogleFonts.adamina(
                      fontSize: 16,
                      color: Colors.cyan,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    media.extension,
                    style: GoogleFonts.adamina(
                      fontSize: 16,
                      color: Colors.cyan,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Divider(),
              ['mp4', 'avi', 'mkv'].contains(media.extension)
                  ? Container(
                      height: 100,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(media.snapshotUrl))),
                    )
                  : ['jpeg', 'jpg', 'png'].contains(media.extension)
                      ? Container(
                          height: 100,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(media.path))),
                        )
                      : Container(),
              if (['mp4', 'avi', 'mkv', 'jpeg', 'jpg', 'png']
                  .contains(media.extension))
                Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: () {
                        cubit.deleteMediaFile(
                          id: media.id,
                          taskId: taskId,
                        );
                      },
                      child: Text(
                        'Remove',
                        style: GoogleFonts.besley(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
