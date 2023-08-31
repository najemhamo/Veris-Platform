



import 'package:flutter/material.dart';
import 'package:veris/features/presentation/widgets/theme/style.dart';

class ForgotPasswordButtonWidget extends StatefulWidget {
  final VoidCallback? onTap;
  final String title;
  const ForgotPasswordButtonWidget({Key? key,required this.title,this.onTap}) : super(key: key);

  @override
  _ForgotPasswordButtonWidgetState createState() => _ForgotPasswordButtonWidgetState();
}

class _ForgotPasswordButtonWidgetState extends State<ForgotPasswordButtonWidget> {
  ///isHover [bool] field manage the hover effect of navigation
  bool _isHover=false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      onHover: (value){
        setState(() {
          _isHover=value;
        });
      },
      child:  Text(
        "${widget.title}",
        style: TextStyle(
            color: _isHover==true?color583BD1:Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
      ),
    );
  }
}
