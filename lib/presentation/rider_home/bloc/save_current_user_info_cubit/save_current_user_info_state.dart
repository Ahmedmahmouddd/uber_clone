part of 'save_current_user_info_cubit.dart';

@immutable
sealed class LoadCurrentUserInfoState {}

final class LoadCurrentUserInfoInitial extends LoadCurrentUserInfoState {}

final class LoadCurrentUserInfoLoading extends LoadCurrentUserInfoState {}

final class LoadCurrentUserInfoSuccess extends LoadCurrentUserInfoState {
  final UserModel userModel;
  LoadCurrentUserInfoSuccess(this.userModel);
}

final class LoadCurrentUserInfoError extends LoadCurrentUserInfoState {
  final String errorMessage;
  LoadCurrentUserInfoError(this.errorMessage);
}
