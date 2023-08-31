
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veris/features/domain/entities/user_entity.dart';
import 'package:veris/features/presentation/cubit/credential/credential_cubit.dart';
import 'package:veris/features/presentation/widgets/common/brand_widget.dart';
import 'package:veris/features/presentation/widgets/common/button_container_widget.dart';
import 'package:veris/features/presentation/widgets/common/common.dart';
import 'package:veris/features/presentation/widgets/common/forgot_password_button_widget.dart';
import 'package:veris/features/presentation/widgets/theme/style.dart';

import '../../../const.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}


class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  bool checkedValue = false;
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
    return _bodyWidget();
  }

  Widget _bodyWidget(){
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
            padding: EdgeInsets.symmetric(horizontal: 40,vertical: 20),
            width: 600,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  boxShadowCustom(),
                ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30,),
                Text(
                  "Veris Forgot Password",
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 20,),
                Divider(color: Colors.grey[500],),
                SizedBox(height: 30,),
                Text("Don't worry! Just fill in your email and ${AppConst.appName} will send you a link to rest your password.",style: TextStyle(fontSize: 14,color: Colors.black.withOpacity(.6),fontStyle: FontStyle.italic),),
                SizedBox(height: 30,),
                Container(
                  height: 45,
                  child: TextField(
                    controller: _emailController,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                        labelText: "Email or ID",
                        border: OutlineInputBorder()
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                ButtonContainerWidget(
                  title: "Send Password Reset Email",
                  onTap: _submitLogin,
                ),
                SizedBox(height: 30,),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Remember the account information? ',
                        style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      ForgotPasswordButtonWidget(title: "Login",onTap: (){
                        Navigator.pushNamedAndRemoveUntil(context, PageConst.loginPage,(route) => false);
                      },)
                    ],
                  ),
                ),
                SizedBox(height: 30,),
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
            SizedBox(width: 10.0,),
            Text("Remember me", style: TextStyle(fontSize: 16),)
          ],
        ),
        Text(
          "Forgot Password?",
          style: TextStyle(
              color: color583BD1, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
  void _submitLogin(){
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
      )
    );
  }

}
