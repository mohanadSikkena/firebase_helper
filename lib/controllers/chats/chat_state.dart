part of 'chat_cubit.dart';

sealed class ChatState {}

final class ChatInitial extends ChatState {}


final class GetUserChatsSuccessState extends ChatState {}
final class GetUserChatsLoadingState extends ChatState {}


final class GetChatMessagesSuccessState extends ChatState {}

final class GetChatMessagesFailState extends ChatState {}



final class ChangeChatsScreenScrollDirection extends ChatState {}



