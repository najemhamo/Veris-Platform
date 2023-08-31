import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veris_mobile/featues/presentation/cubit/auth/auth_cubit.dart';
import 'button_container_widget.dart';

class AlertMessageWidget extends StatelessWidget {
  final String title;

  const AlertMessageWidget({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(title),
              SizedBox(
                height: 10,
              ),
              ButtonContainerWidget(
                title: "Logout",
                onTap: () {
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
