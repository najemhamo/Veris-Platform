import 'package:flutter/material.dart';
import 'package:veris_mobile/featues/domain/entities/equipment_entity.dart';
import 'package:veris_mobile/featues/domain/entities/userEquipmentEntity.dart';
import 'const.dart';
import 'featues/presentation/pages/forgot_page.dart';
import 'featues/presentation/pages/item_single_page.dart';
import 'featues/presentation/pages/login_page.dart';

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
            widget: ForgetPassPage(),
          );
        }
      case PageConst.loginPage:
        {
          return materialBuilder(
            widget: LoginPage(),
          );
        }
        case PageConst.singleItemPage:
        {
          if (args is UserEquipmentEntity){

            return materialBuilder(
              widget: SingleItemPage(userEquipment: args,),
            );
          }else{
            return materialBuilder(
              widget: ErrorPage(),
            );
          }


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
