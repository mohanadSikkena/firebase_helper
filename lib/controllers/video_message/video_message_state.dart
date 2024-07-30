part of 'video_message_cubit.dart';


sealed class VideoMessageState {}

final class VideoMessageInitial extends VideoMessageState {}
final class CacheVideoInitialized extends VideoMessageState {
  String imageUrl;

  CacheVideoInitialized(this.imageUrl);
}
