part of 'login_cubit.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}
final class LoginLoadingState extends LoginState {}
final class LoginSuccessState extends LoginState {}
final class LoginFailState extends LoginState {
  final CustomErrors error;
  LoginFailState(this.error);
}

