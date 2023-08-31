

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget profileImageWidget({String? imageUrl,File? image}){
  if (image==null){
    if (imageUrl==null || imageUrl=="")
      return ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Image.asset(
          'assets/profile_default.png',
          fit: BoxFit.cover,
        ),
      );
    else
      return ClipRRect(
        borderRadius: BorderRadius.circular(150),
        child: CachedNetworkImage(
          imageUrl: "$imageUrl",
          fit: BoxFit.cover,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              SizedBox(height: 50,width: 50,child: Container(margin: EdgeInsets.all(20),child: CircularProgressIndicator())),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      );
  }else{
    return ClipRRect(   borderRadius: BorderRadius.circular(50),child: Image.file(image,fit: BoxFit.cover,));
  }
}