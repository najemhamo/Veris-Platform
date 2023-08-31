


import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

BoxDecoration boxDecorationWithShadow=BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(.2),
      spreadRadius: 2,
      blurRadius: 2,
    ),
  ],
);

void toast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.deepOrange,
      textColor: Colors.white,
      fontSize: 16.0);
}

Widget loadingIndicatorProgressBar({String? data}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          backgroundColor: Colors.orange,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          data==null?"Setting up your account please wait..":data,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        )
      ],
    ),
  );
}

BorderRadius borderRadiusAll({double radius = 0.0}) {
  return BorderRadius.all(Radius.circular(radius));
}

BoxShadow boxShadowCustom() => BoxShadow(
    color: Colors.black.withOpacity(.2),
    blurRadius: 1,
    spreadRadius: 1,
    offset: Offset(0.0, 5.0));

Widget textFieldFromContainer(
    {bool isPassword = false,
      TextInputType textInputType = TextInputType.text,
      String? hintText,
      TextEditingController? textEditingController,
      IconData? icon,int? maxLines}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      borderRadius: borderRadiusAll(radius: 10),
      border: Border.all(color: Colors.black.withOpacity(.4), width: 1.5),
    ),
    child: TextFormField(
      obscureText: isPassword == false ? false : true,
      controller: textEditingController,
      keyboardType: textInputType,
      maxLines: maxLines==null?1:maxLines==0?null:maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        border: InputBorder.none,
        suffixIcon: icon == null ? null : Icon(icon),
      ),
    ),
  );
}