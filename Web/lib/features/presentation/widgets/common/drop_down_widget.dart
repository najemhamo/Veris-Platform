import 'package:flutter/material.dart';
import 'package:veris/const.dart';
import 'package:veris/features/presentation/widgets/theme/style.dart';


typedef UserTypeCallBack=Function(String type);
class DropDownWidget extends StatefulWidget {
  final UserTypeCallBack userTypeCallBack;
  final List<String> userTypes;
  const DropDownWidget({Key? key,required this.userTypeCallBack,required this.userTypes}) : super(key: key);

  @override
  _DropDownWidgetState createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  String _selectedCity = "Select user";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: colorF8FAFC,
        border: Border.all(color: Colors.black,width: 1.0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
            isExpanded: true,
            hint: Text(_selectedCity),
            onChanged: (String? userType) {
              setState(() {
                _selectedCity = userType!;
              });
              widget.userTypeCallBack(userType!);
            },
            items: widget.userTypes.map(
                  (userType) => DropdownMenuItem(
                    child: Text("$userType"),
                    value: userType,
                  ),
                )
                .toList()),
      ),
    );
  }
}
