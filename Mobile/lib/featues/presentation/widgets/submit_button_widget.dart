import 'package:flutter/material.dart';
import 'package:veris_mobile/featues/presentation/widgets/theme/style.dart';

class SubmitButtonWidget extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;
  final double? width;
  final Color? color;

  const SubmitButtonWidget({Key? key,this.color, required this.text, this.onTap,this.width=110})
      : super(key: key);

  @override
  _SubmitButtonWidgetState createState() => _SubmitButtonWidgetState();
}

class _SubmitButtonWidgetState extends State<SubmitButtonWidget> {
  bool _isHover = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      onHover: (value) {
        setState(() {
          _isHover = value;
        });
      },
      child: Container(
        width: 60,
        height: 30,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(.4), width: 1),
          color: widget.color==null?color583BD1:widget.color,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: _isHover == true?Colors.black:Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
