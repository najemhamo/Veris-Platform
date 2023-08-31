


import 'package:flutter/material.dart';
import 'package:veris/features/presentation/widgets/theme/style.dart';

import '../../../../const.dart';

///[BrandWidget] - if you want you can replace with [String] url

class BrandWidget extends StatelessWidget {
  const BrandWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 108,
          height: 108,
          child: Image.asset("assets/logo.png"),
        ),
        //Text("${AppConst.appName}",style: TextStyle(color: color583BD1,fontSize: 18,fontWeight: FontWeight.bold),)
      ],
    );
  }
}
