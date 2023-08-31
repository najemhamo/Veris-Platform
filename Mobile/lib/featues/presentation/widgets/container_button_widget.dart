

import 'package:flutter/material.dart';
import 'package:veris_mobile/featues/presentation/widgets/theme/style.dart';

class ContainerButtonWidget extends StatelessWidget {
  final String title;
  final VoidCallback? tonTap;
  const ContainerButtonWidget({Key? key,required this.title,this.tonTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap:tonTap,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text("$title",style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w500),),
      ),
    );
  }
}
