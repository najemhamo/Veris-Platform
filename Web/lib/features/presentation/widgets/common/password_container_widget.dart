import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:veris/features/presentation/widgets/theme/style.dart';

class PasswordContainerWidget extends StatefulWidget {
  final TextEditingController? controller;
  const PasswordContainerWidget({Key? key,this.controller}) : super(key: key);

  @override
  _PasswordContainerWidgetState createState() => _PasswordContainerWidgetState();
}

class _PasswordContainerWidgetState extends State<PasswordContainerWidget> {

  bool isObscureText=true;

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 45,
      padding: EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        color: colorF8FAFC,
        border: Border.all(color: Colors.black,width: 1.0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: widget.controller,
        obscureText: isObscureText,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
            hintText: "Password",
            border: InputBorder.none,
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
    );
  }
}
