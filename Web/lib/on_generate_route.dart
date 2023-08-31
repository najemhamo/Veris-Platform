import 'package:flutter/material.dart';
import 'package:veris/features/presentation/pages/forgot_password_page.dart';
import 'package:veris/features/presentation/pages/login_page.dart';
import 'const.dart';

class OnGenerateRoute {
  static Route<dynamic> route(RouteSettings settings) {
    final args = settings.arguments;


    switch (settings.name) {
      case PageConst.settingsPage:
        {
          return materialBuilder(
            widget: Container(),
          );
        }
      case PageConst.forgotPage:
        {
          return materialBuilder(
            widget: ForgotPasswordPage(),
          );
        }
      case PageConst.loginPage:
        {
          return materialBuilder(
            widget: LoginPage(),
          );
        }
      default:
        return materialBuilder(
          widget: ErrorPage(),
        );
    }
  }
}

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("error"),
      ),
      body: Center(
        child: Text("error"),
      ),
    );
  }
}

MaterialPageRoute materialBuilder({required Widget widget}) {
  return MaterialPageRoute(builder: (_) => widget);
}
