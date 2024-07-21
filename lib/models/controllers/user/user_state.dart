part of 'user_cubit.dart';

sealed class UserState {}

final class UserInitial extends UserState {}
final class GetUserDataLoadingState extends UserState {}
final class GetUserDataSuccessState extends UserState {}
final class GetUserDataFailState extends UserState {}
final class GetUsersDataLoadingState extends UserState {}
final class GetUsersDataSuccessState extends UserState {}
final class GetUsersDataFailState extends UserState {}


final class UpdateUserDataLoadingState extends UserState {}
final class UpdateUserDataSuccessState extends UserState {}
final class UpdateUserDataFailState extends UserState {}

final class UpdateUserImageLoadingState extends UserState {}
final class UpdateUserImageSuccessState extends UserState {}
final class UpdateUserImageFailState extends UserState {}


final class UserSignOutLoadingState extends UserState {}
final class UserSignOutSuccessState extends UserState {}
final class UserSignOutFailState extends UserState {}
