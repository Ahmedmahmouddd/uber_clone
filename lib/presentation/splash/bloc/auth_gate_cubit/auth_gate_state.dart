part of 'auth_gate_cubit.dart';

@immutable
sealed class AuthGateState {}

final class AuthGateInitial extends AuthGateState {}

final class AuthGateAuthenticatedAsRider extends AuthGateState {}

final class AuthGateAuthenticatedAsDriver extends AuthGateState {}

final class AuthGateUnAuthenticated extends AuthGateState {}

final class AuthGateFailure extends AuthGateState {
  final String errorMessage;
  AuthGateFailure({required this.errorMessage});
}
