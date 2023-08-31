import 'package:flutter/material.dart';
import 'package:veris/features/presentation/widgets/theme/style.dart';

class TextFieldWidget extends StatelessWidget {
  final String textName;
  final String hintTextName;
  const TextFieldWidget({Key? key, required this.textName, required this.hintTextName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          textName,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        SizedBox(height: 5.0,),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          width: 270,
          height: 40,
          decoration: BoxDecoration(
              color: colorF8FAFC,
          ),
          child: TextField(
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              hintText: hintTextName,
              border: InputBorder.none,
            ),
          ),
        )
      ],
    );
  }
}

class TextFieldFullWidthWidget extends StatelessWidget {
  final String textName;
  final String hintTextName;
  final int? maxLine;
  final TextEditingController? textEditingController;
  const TextFieldFullWidthWidget({Key? key,this.textEditingController, this.maxLine=1,required this.textName, required this.hintTextName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          textName,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        SizedBox(height: 5.0,),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          width: MediaQuery.of(context).size.width,
          height: maxLine==1?40:null,
          decoration: BoxDecoration(
            color: colorF8FAFC,
            border: Border.all(color: Colors.black,width: 1.0),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: textEditingController,
            maxLines: maxLine,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              hintText: hintTextName,
              border: InputBorder.none,
            ),
          ),
        )
      ],
    );
  }
}
