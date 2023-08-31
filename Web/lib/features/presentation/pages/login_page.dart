import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:veris/features/domain/entities/user_entity.dart';
import 'package:veris/features/presentation/cubit/auth/auth_cubit.dart';
import 'package:veris/features/presentation/cubit/credential/credential_cubit.dart';
import 'package:veris/features/presentation/widgets/common/brand_widget.dart';
import 'package:veris/features/presentation/widgets/common/button_container_widget.dart';
import 'package:veris/features/presentation/widgets/common/common.dart';
import 'package:veris/features/presentation/widgets/common/forgot_password_button_widget.dart';

import '../../../const.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool checkedValue = false;
  bool isObscureText = true;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CredentialCubit, CredentialState>(
      listener: (context, credentialState) {
        if (credentialState is CredentialSuccess) {
          BlocProvider.of<AuthCubit>(context).loggedIn();
        }
        if (credentialState is CredentialFailure) {
          toast("Invalid Email & password");
        }
      },
      builder: (context, credentialState) {
        if (credentialState is CredentialLoading) {
          return Scaffold(
            body: loadingIndicatorProgressBar(),
          );
        }
        if (credentialState is CredentialSuccess) {
          return BlocBuilder<AuthCubit, AuthState>(
            builder: (context, authState) {
              if (authState is Authenticated) {
                return HomePage(
                  uid: authState.uid,
                );
              } else {
                print("Unauthenticsted");
                return _bodyWidget();
              }
            },
          );
        }

        return _bodyWidget();
      },
    );
  }

  Widget _bodyWidget() {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 35),
          height: 85,
          decoration: BoxDecoration(color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BrandWidget(),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 20.0),
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            width: 600,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  boxShadowCustom(),
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Veris Login",
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  color: Colors.grey[500],
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 45,
                  child: TextField(
                    controller: _emailController,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                        labelText: "Email or ID", border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 45,
                  child: TextField(
                    controller: _passwordController,
                    obscureText: isObscureText,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(),
                        suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                isObscureText = !isObscureText;
                              });
                              print(isObscureText);
                            },
                            child: Icon(isObscureText == true
                                ? MaterialIcons.panorama_fish_eye
                                : MaterialIcons.remove_red_eye))),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                _forgotPasswordWidget(),
                SizedBox(
                  height: 30,
                ),
                ButtonContainerWidget(
                  title: "Login",
                  onTap: _submitLogin,
                ),
                SizedBox(
                  height: 15,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Text("New User? ", style: TextStyle(fontSize: 16),),
                //     InkWell(onTap: () {
                //       Navigator.pushNamedAndRemoveUntil(context, PageConst.signUpPage, (route) => false,arguments: []);
                //     },
                //       child: Text("Sign up FREE Now"),
                //     )
                //   ],
                // ),
                // SizedBox(height: 15.0,),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      " By connecting to ${AppConst.appName}, I have read and agreed to ${AppConst.appName} Terms of User and Privacy Policy.",
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ))
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _forgotPasswordWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              activeColor: Colors.redAccent,
              value: checkedValue,
              onChanged: (newValue) {
                setState(() {
                  checkedValue = newValue!;
                });
              },
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(
              "Remember me",
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
        ForgotPasswordButtonWidget(
          title: "Forgot Password?",
          onTap: () {
            Navigator.pushNamed(context, PageConst.forgotPage);
          },
        )
      ],
    );
  }

  void _submitLogin() {
    if (_emailController.text.isEmpty) {
      toast('enter your email');
      return;
    }
    if (_passwordController.text.isEmpty) {
      toast('enter your password');
      return;
    }
    BlocProvider.of<CredentialCubit>(context).signInSubmit(
        user: UserEntity(
      email: _emailController.text,
      password: _passwordController.text,
    ));
  }
}
