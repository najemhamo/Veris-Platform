

import 'package:flutter/material.dart';

class TextFieldContainerWidget extends StatelessWidget {
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final String? hintText;
  final double? borderRadius;
  final Color? color;
  final VoidCallback? iconClickEvent;
  const TextFieldContainerWidget({Key? key,this.iconClickEvent,this.color,this.borderRadius=10,this.hintText,this.keyboardType,this.controller,this.prefixIcon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: color==null?Colors.grey.withOpacity(.2):color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        keyboardType: keyboardType,
        controller:controller,
        decoration: InputDecoration(
          hintText: hintText,
            border: InputBorder.none,
            prefixIcon: InkWell(onTap: iconClickEvent,child: Icon(prefixIcon))
        ),
      ),
    );
  }
}
