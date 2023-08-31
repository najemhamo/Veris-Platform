import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veris_mobile/featues/data/remote/models/user_model.dart';
import 'package:veris_mobile/featues/presentation/cubit/auth/auth_cubit.dart';
import 'package:veris_mobile/featues/presentation/cubit/user/user_cubit.dart';
import 'package:veris_mobile/featues/presentation/pages/home_page.dart';
import 'package:veris_mobile/featues/presentation/widgets/alert_message_widget.dart';
import 'package:veris_mobile/featues/presentation/widgets/container_button_widget.dart';

import '../../../const.dart';

class HomeScreen extends StatelessWidget {
  final String uid;

  const HomeScreen({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(builder: (context, userState) {
      if (userState is UserLoaded) {
        final user = userState.users
            .firstWhere((user) => user.uid == uid, orElse: () => UserModel());

        if (user.isDisable == true) {
          return AlertMessageWidget(title: AppConst.disabledMessage);
        } else if (user.accountType == UserConst.student) {
          return HomePage(user: user);
        } else {
          return Scaffold(
            body: Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(AppConst.adminMessage),
                    SizedBox(
                      height: 10,
                    ),
                    ContainerButtonWidget(
                      title: "Logout",
                      tonTap: () {
                        BlocProvider.of<AuthCubit>(context).loggedOut();
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        }
      }

      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
  }
}
