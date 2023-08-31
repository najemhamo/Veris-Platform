import 'package:flutter/material.dart';
import 'package:veris_mobile/featues/presentation/widgets/theme/style.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController? searchController;
  final VoidCallback? onClearSearch;
  final String? searchHintText;

  const SearchWidget({Key? key, this.searchHintText,this.searchController, this.onClearSearch})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 25,right: 30,left: 20),
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(.3),
              spreadRadius: 1,
              offset: Offset(0, 0.50))
        ],
      ),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: "$searchHintText",
          border: InputBorder.none,
          prefixIcon: InkWell(
              child: Icon(
                Icons.search,
                size: 25,
                color: primaryColor,
              )),
          suffixIcon: InkWell(
              onTap: onClearSearch,
              child: Icon(
                Icons.close,
                size: 25,
                color: primaryColor,
              )),
          hintStyle: TextStyle(),
        ),
        style: TextStyle(fontSize: 16.0),
      ),
    );
  }
}
