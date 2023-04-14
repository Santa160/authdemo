import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_flow_state.dart';

class AuthFlowCubit extends Cubit<AuthFlowState> {
  AuthFlowCubit() : super(const AuthFlowState(status: Status.initial)) {
    var auth = FirebaseAuth.instance;
    auth.authStateChanges().listen((event) {
      if (event != null) {
        emit(const AuthFlowState(status: Status.loggedIn));
      } else {
        emit(const AuthFlowState(status: Status.loggedOut));
      }
    });
  }
}
