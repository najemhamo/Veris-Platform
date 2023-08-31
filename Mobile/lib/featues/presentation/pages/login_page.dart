import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:veris_mobile/featues/domain/entities/user_entity.dart';
import 'package:veris_mobile/featues/presentation/cubit/auth/auth_cubit.dart';
import 'package:veris_mobile/featues/presentation/cubit/credential/credential_cubit.dart';
import 'package:veris_mobile/featues/presentation/screens/home_screen.dart';
import 'package:veris_mobile/featues/presentation/widgets/common.dart';
import 'package:veris_mobile/featues/presentation/widgets/theme/style.dart';
import '../../../const.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isShowPassword=true;

  GlobalKey<ScaffoldState> _scaffoldGlobalKey=GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldGlobalKey,
      body: BlocConsumer<CredentialCubit,CredentialState>(
        listener: (context,credentialState){
          if (credentialState is CredentialSuccess) {
            BlocProvider.of<AuthCubit>(context).loggedIn();
            // Future.delayed(Duration(seconds: 2),(){
            //   Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            // });
          }
          if (credentialState is CredentialFailure){
            snackBar(msg: 'Invalid Email & Password ',scaffoldState: _scaffoldGlobalKey);
          }
        },
        builder: (context,credentialState){
          if (credentialState is CredentialLoading) {
            return Center(
              child: CircularProgressIndicator(backgroundColor: primaryColor,color: Colors.teal,),
            );
          }
          if (credentialState is CredentialSuccess) {
            return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                if (authState is Authenticated) {
                  return HomeScreen(uid: authState.uid,);
                } else {
                  print("Unauthenticsted");
                  return _bodyWidget();
                }
              },
            );
          }

          return _bodyWidget();
        },
      ),
    );
  }
 Widget _bodyWidget(){
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 22, vertical: 32),
        child: Column(
          children: <Widget>[
            SizedBox(height: 20,),
            Container(
                alignment: Alignment.topLeft,
                child: Text(
                  'Login',
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w700,
                      color: primaryColor),
                )),
            SizedBox(
              height: 10,
            ),
            Divider(
              thickness: 1,
            ),
            // Container(
            //   child: SvgPicture.asset('assets/login_image.svg'),
            // ),
            SizedBox(
              height: 17,
            ),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(.2),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.grey,
                  ),
                  hintText: 'Email',
                  hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 17,
                      fontWeight: FontWeight.w400),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(.2),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: TextField(
                obscureText: _isShowPassword,
                controller: _passwordController,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.grey,
                  ),
                  hintText: 'Password',
                  hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 17,
                      fontWeight: FontWeight.w400),
                  border: InputBorder.none,
                  suffixIcon: InkWell(onTap: (){
                    setState(() {
                      _isShowPassword=_isShowPassword==false?true:false;
                    });
                  },child: Icon(_isShowPassword==false?MaterialIcons.remove_red_eye:MaterialIcons.panorama_fish_eye)),
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: (){
                  Navigator.pushNamed(context, PageConst.forgotPage);
                },
                child: Text(
                  'Forgot password?',
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: _submit,
              child: Container(
                alignment: Alignment.center,
                height: 44,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),

          ],
        ),
      ),
    );
  }


  void _submit() {
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