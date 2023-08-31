

import 'dart:io';
import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veris/features/data/remote/models/user_model.dart';
import 'package:veris/features/domain/entities/history_entity.dart';
import 'package:veris/features/domain/entities/user_entity.dart';
import 'package:veris/features/presentation/cubit/history/history_cubit.dart';
import 'package:veris/features/presentation/cubit/user/user_cubit.dart';
import 'package:veris/features/presentation/widgets/common/common.dart';
import 'package:veris/features/presentation/widgets/common/submit_button_widget.dart';
import 'package:veris/features/presentation/widgets/common/text_field_widget.dart';
import 'package:veris/features/presentation/widgets/nav_widgets/profile_image_widget.dart';
import 'package:veris/features/presentation/widgets/theme/style.dart';

class SProfileWidget extends StatefulWidget {
  const SProfileWidget({Key? key}) : super(key: key);

  @override
  _SProfileWidgetState createState() => _SProfileWidgetState();
}

class _SProfileWidgetState extends State<SProfileWidget> {


  TextEditingController _nameController = TextEditingController();
  TextEditingController _statusController = TextEditingController();

  FirebaseStorage _storage = FirebaseStorage.instance;

  bool _isUploadingImage=false;
  String? _imageUrl;
  String? _imagePath;
  File? _pickedImage;


  @override
  void dispose() {
    _nameController.dispose();
    _statusController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit,UserState>(builder: (context,userState){


      if (userState is UserLoaded){


        final user=userState.users.firstWhere((user) => user.uid==userState.uid,orElse: () => UserModel());


        return Container(
          padding: EdgeInsets.only(left: 50,right: 150,top: 30),
          child: Column(
            children: [
              SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFieldFullWidthWidget(
                          textName: 'Name',
                          hintTextName: '${user.name}',
                          textEditingController: _nameController,
                        ),
                        SizedBox(height: 15,),
                        AbsorbPointer(
                          child: TextFieldFullWidthWidget(
                            textName: 'Email',
                            hintTextName: '${user.email}',
                          ),
                        ),
                        SizedBox(height: 15,),
                        TextFieldFullWidthWidget(
                          textName: 'Bio',
                          hintTextName: user.aboutMe==""||user.aboutMe==null?"Please write anything about yourself.":"${user.aboutMe}",
                          maxLine: 8,
                          textEditingController: _statusController,
                        ),
                        SizedBox(height: 15,),
                        SubmitButtonWidget(
                          text: "Update Profile",
                          onTap: (){
                            BlocProvider.of<UserCubit>(context).updateUser(user: UserEntity(
                              uid: userState.uid,
                              name: _nameController.text,
                              profileUrl: _imageUrl,
                            ));

                            BlocProvider.of<HistoryCubit>(context)
                                .addNewEquipments(equipmentEntity: HistoryEntity(
                              event: "User has been updated profile",
                              actionDoneBy: "student(${_nameController.text})",
                              name: "${_nameController.text}",
                              time: Timestamp.now(),
                            ));
                            toast("profile updated Successfully");

                          },
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: 50,),
                  InkWell(onTap: (){
                    _startFilePicker();
                  },child: _profileWidget(
                    profile: user.profileUrl,
                  ))
                ],
              ),
            ],
          ),
        );
      }

      return Container(
        margin: EdgeInsets.only(top: 40),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
  }

  Widget _profileWidget({String? profile = "", bool isColor = false}) {
    return Column(
      children: [
        SizedBox(height: 10,),
        Text("Profile Picture"),
        SizedBox(height: 10,),
        InkWell(
          onTap: ()async{
            _startFilePicker();
          },
          child: Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              color: isColor == false ? Colors.grey.withOpacity(.4) : color583BD1,
            ),
            child:_isUploadingImage==true?Center(
              child: CircularProgressIndicator(),
            ):profileImageWidget(
                imageUrl: profile,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserCubit>(context).getUsers();
  }

  _startFilePicker() async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement()..accept="image/*";
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      // read file content as dataURL
      final file = uploadInput.files!.first;
      final reader = html.FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) async{


        setState(() {
          _isUploadingImage=true;
        });
        final ref = _storage.ref().child(
            "images/${DateTime.now().microsecondsSinceEpoch}.png");

        print(ref.fullPath);

        final uploadTask = ref.putBlob(file);
        print("bytes transf :${uploadTask.snapshot.bytesTransferred}");
        if (uploadTask.snapshot.totalBytes==uploadTask.snapshot.bytesTransferred){
          toast("Image updated");
        }

        final url= (await uploadTask.whenComplete((){
          print("uploaded success fully");
          setState(() {
            _isUploadingImage=false;
          });
        })).ref.getDownloadURL();

        final urlImage=await url;
        setState((){
          _imageUrl=urlImage;
        });
        toast("Image Picked Successfully, update your profile");
        print("url ${await url}");

      });
    });
  }
}