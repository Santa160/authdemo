import 'package:authdemo/router/app.route.gr.dart';
import 'package:auto_route/auto_route.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(path: '/', page: AuthFlowRoute.page, children: [
          AutoRoute(page: HomeRoute.page),
          AutoRoute(page: LoginRoute.page),
        ]),
      ];
}
