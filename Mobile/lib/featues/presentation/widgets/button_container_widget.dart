import 'package:flutter/material.dart';
import 'package:veris_mobile/featues/presentation/widgets/theme/style.dart';

class ButtonContainerWidget extends StatefulWidget {
  final VoidCallback? onTap;
  final String title;

  const ButtonContainerWidget({Key? key, required this.title, this.onTap})
      : super(key: key);

  @override
  _ButtonContainerWidgetState createState() => _ButtonContainerWidgetState();
}

class _ButtonContainerWidgetState extends State<ButtonContainerWidget> {
  ///isHover [bool] field manage the hover effect of navigation
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
        height: 35,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(.4),width: 1),
            color: _isHover == true ? color583BD1 : color583BD1.withOpacity(.2),
            borderRadius: BorderRadius.circular(3.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 8.0,
            ),
            Text(
              "${widget.title}",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: _isHover == true?Colors.white:Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
