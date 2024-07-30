part of 'signup_cubit.dart';

sealed class SignupState {}

final class SignupInitial extends SignupState {}

final class SignupLoadingState extends SignupState {}

final class SignupSuccessState extends SignupState {}

final class SignupFailState extends SignupState {
  final CustomErrors error ;
  SignupFailState(this.error);
}

final class CreateUserLoadingState extends SignupState {}

final class CreateUserSuccessState extends SignupState {}
final class CreateUserFailState extends SignupState {
  final CustomErrors error ;
  CreateUserFailState(this.error);
}

final class ChangeSelectedGenderValue extends SignupState {}

