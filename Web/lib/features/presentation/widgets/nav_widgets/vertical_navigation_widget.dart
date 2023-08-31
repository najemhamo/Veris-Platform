import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'nav_brand_header_widget.dart';
import 'nav_button_widget.dart';

typedef OnPageChangeIndexCallBack = Function(int index);

class VerticalNavigationWidget extends StatefulWidget {
  final OnPageChangeIndexCallBack onPageChangeIndexCallBack;

  const VerticalNavigationWidget(
      {Key? key, required this.onPageChangeIndexCallBack})
      : super(key: key);

  @override
  _VerticalNavigationWidgetState createState() =>
      _VerticalNavigationWidgetState();
}

class _VerticalNavigationWidgetState extends State<VerticalNavigationWidget> {
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
            title: "Add User",
              isSelected: _buttonIndex == 3 ? true : false,
              icon: AntDesign.adduser,
              onTap: () {
                setState(() {
                  _buttonIndex = 3;
                });
                widget.onPageChangeIndexCallBack(3);
              }),

          NavButtonWidget(
             title: "Users",
              isSelected: _buttonIndex == 4 ? true : false,
              icon: AntDesign.user,
              onTap: () {
                setState(() {
                  _buttonIndex = 4;
                });
                widget.onPageChangeIndexCallBack(4);
              }),

          NavButtonWidget(
            title: "Add Equipment",
              isSelected: _buttonIndex == 5 ? true : false,
              icon: AntDesign.tool,
              onTap: () {
                setState(() {
                  _buttonIndex = 5;
                });
                widget.onPageChangeIndexCallBack(5);
              }),
          NavButtonWidget(
            title: "Details",
              isSelected: _buttonIndex == 6 ? true : false,
              icon: MaterialIcons.details,
              onTap: () {
                setState(() {
                  _buttonIndex = 6;
                });
                widget.onPageChangeIndexCallBack(6);
              }),
          NavButtonWidget(
              title: "Reports",
              isSelected: _buttonIndex == 7 ? true : false,
              icon: MaterialIcons.report,
              onTap: () {
                setState(() {
                  _buttonIndex = 7;
                });
                widget.onPageChangeIndexCallBack(7);
              }),
        ],
      ),
    );
  }
}
