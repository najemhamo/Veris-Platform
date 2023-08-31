import 'package:flutter/material.dart';
import 'package:veris/features/presentation/widgets/theme/style.dart';

class NavButtonWidget extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool? isSelected;
  final String? title;

  const NavButtonWidget(
      {Key? key, this.title, required this.icon, this.onTap, this.isSelected})
      : super(key: key);

  @override
  _NavButtonWidgetState createState() => _NavButtonWidgetState();
}

class _NavButtonWidgetState extends State<NavButtonWidget> {
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
      child: Column(
        children: [
          Container(
            height: 45,
            width: 45,
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: _isHover == true || widget.isSelected == true
                  ? color583BD1.withOpacity(.1)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                widget.icon,
                size: 24,
                color: _isHover == true || widget.isSelected == true
                    ? color583BD1
                    : Colors.black,
              ),
            ),
          ),
          SizedBox(height: 2,),
          Text("${widget.title}",style: TextStyle(
            color:_isHover == true || widget.isSelected == true
                ? color583BD1
                : Colors.black.withOpacity(.6) ,
          ),),
        ],
      ),
    );
  }
}
