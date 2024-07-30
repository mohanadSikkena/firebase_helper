import 'package:bloc/bloc.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:meta/meta.dart';
import 'package:video_player/video_player.dart';

part 'video_message_state.dart';

class VideoMessageCubit extends Cubit<VideoMessageState> {
  VideoMessageCubit() : super(VideoMessageInitial());

  late CachedVideoPlayerPlusController controller;

  initializeVideoController(String videoUrl){
    controller = CachedVideoPlayerPlusController.networkUrl(
        Uri.parse(videoUrl),
        videoPlayerOptions: VideoPlayerOptions())
      ..initialize().then((value) {
        emit(CacheVideoInitialized(videoUrl));
      }).onError((error, stackTrace) {
        print("error here$error");
      });
  }



}
