part of 'chat_cubit.dart';

sealed class ChatState {}

final class ChatInitial extends ChatState {}
final class GetUserChatsSuccessState extends ChatState {}
final class GetChatMessagesSuccessState extends ChatState {}
