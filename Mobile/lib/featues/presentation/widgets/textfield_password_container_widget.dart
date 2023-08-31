

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class TextFieldPasswordContainerWidget extends StatefulWidget {
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final String? hintText;
  const TextFieldPasswordContainerWidget({Key? key,this.hintText,this.keyboardType,this.controller,this.prefixIcon}) : super(key: key);

  @override
  _TextFieldPasswordContainerWidgetState createState() => _TextFieldPasswordContainerWidgetState();
}

class _TextFieldPasswordContainerWidgetState extends State<TextFieldPasswordContainerWidget> {

  bool isObscureText=true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        obscureText: isObscureText,
        keyboardType: widget.keyboardType,
        controller:widget.controller,
        decoration: InputDecoration(
          hintText: widget.hintText,
            border: InputBorder.none,
            suffixIcon:InkWell(onTap: (){
             setState(() {
               isObscureText=!isObscureText;
             });
            },child: Icon(isObscureText==true?MaterialIcons.panorama_fish_eye:MaterialIcons.remove_red_eye)) ,
            prefixIcon: Icon(widget.prefixIcon)
        ),
      ),
    );
  }
}
