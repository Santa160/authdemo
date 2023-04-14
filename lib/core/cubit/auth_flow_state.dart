part of 'auth_flow_cubit.dart';

enum Status { initial, loggedIn, loggedOut }

class AuthFlowState extends Equatable {
  const AuthFlowState({required this.status});
  final Status status;

  @override
  List<Object> get props => [status];
}
