import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:veris/features/presentation/widgets/nav_widgets/nav_brand_header_widget.dart';
import 'package:veris/features/presentation/widgets/nav_widgets/nav_button_widget.dart';

typedef OnPageChangeIndexCallBack = Function(int index);

class SVerticalNavigationWidget extends StatefulWidget {
  final OnPageChangeIndexCallBack onPageChangeIndexCallBack;

  const SVerticalNavigationWidget(
      {Key? key, required this.onPageChangeIndexCallBack})
      : super(key: key);

  @override
  _SVerticalNavigationWidgetState createState() =>
      _SVerticalNavigationWidgetState();
}

class _SVerticalNavigationWidgetState extends State<SVerticalNavigationWidget> {
  int _buttonIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 128,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.2),
            offset: Offset(0.0, 2.2),
            blurRadius: 2,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          NavBrandHeaderWidget(),
          NavButtonWidget(
              title: "Equipments",
              isSelected: _buttonIndex == 1 ? true : false,
              icon: Feather.grid,
              onTap: () {
                setState(() {
                  _buttonIndex = 1;
                });
                widget.onPageChangeIndexCallBack(1);
              }),
          NavButtonWidget(
            title: "Profile",
            isSelected: _buttonIndex == 2 ? true : false,
            icon: MaterialCommunityIcons.face_profile,
            onTap: () {
              setState(() {
                _buttonIndex = 2;
              });
              widget.onPageChangeIndexCallBack(2);
            },
          ),
          NavButtonWidget(
            title: "My Equipments",
              isSelected: _buttonIndex == 3 ? true : false,
              icon: AntDesign.adduser,
              onTap: () {
                setState(() {
                  _buttonIndex = 3;
                });
                widget.onPageChangeIndexCallBack(3);
              }),

        ],
      ),
    );
  }
}
