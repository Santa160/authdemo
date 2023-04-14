import 'package:authdemo/router/app.route.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/auth_flow_cubit.dart';

@RoutePage()
class AuthFlowScreen extends StatelessWidget {
  const AuthFlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var state = context.watch<AuthFlowCubit>().state;
    return AutoRouter.declarative(
      routes: (handler) {
        switch (state.status) {
          case Status.initial:
            return [];
          case Status.loggedIn:
            return [const HomeRoute()];
          case Status.loggedOut:
            return [const LoginRoute()];
        }
      },
    );
  }
}
