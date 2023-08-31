import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:veris_mobile/featues/data/remote/data_sources/storage_provider.dart';
import 'package:veris_mobile/featues/domain/entities/history_entity.dart';
import 'package:veris_mobile/featues/domain/entities/user_entity.dart';
import 'package:veris_mobile/featues/presentation/cubit/history/history_cubit.dart';
import 'package:veris_mobile/featues/presentation/cubit/user/user_cubit.dart';
import 'package:veris_mobile/featues/presentation/widgets/common.dart';
import 'package:veris_mobile/featues/presentation/widgets/profile_image_widget.dart';
import 'package:veris_mobile/featues/presentation/widgets/text_field_widget.dart';
import 'package:veris_mobile/featues/presentation/widgets/textfield_container_widget.dart';

class ProfilePage extends StatefulWidget {
  final UserEntity user;

  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserEntity get userData=> widget.user;
  TextEditingController? _nameController;
  TextEditingController? _emailController;
  TextEditingController? _numController;
  TextEditingController? _phoneNumberController;
  FirebaseStorage _storage = FirebaseStorage.instance;



  File? _image;
  String? _profileUrl;
  String? _username;
  String? _phoneNumber;
  final picker = ImagePicker();


  void dispose() {
    _nameController!.dispose();
    _emailController!.dispose();
    _numController!.dispose();
    _phoneNumberController!.dispose();
    super.dispose();
  }
  @override
  void initState() {
    _nameController = TextEditingController(text: "${userData.name}");
    _emailController = TextEditingController(text: "${userData.email}");
    _numController = TextEditingController(text: "${userData.phoneNumber}");
    _phoneNumberController = TextEditingController(text: "${userData.phoneNumber}");
    super.initState();
  }


  Future getImage() async {
    try {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
          StorageProviderRemoteDataSource.uploadFile(file: _image!).then((value) {

            setState(() {
              _profileUrl=value;
            });

            toast("Image updated");
          });
        } else {
          print('No image selected.');
        }
      });
    } catch (e) {
      toast("error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: (){
                  getImage();
                },
                child: Container(
                  height: 62,
                  width: 62,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.2),
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  child: profileImageWidget(
                    image: _image,
                    imageUrl: userData.profileUrl,
                  ),
                ),
              ),
              SizedBox(
                height: 28,
              ),
              TextFieldContainerWidget(
                controller: _nameController,
                hintText: "name",
                prefixIcon: Icons.person,
                keyboardType: TextInputType.text,
              ),
              SizedBox(
                height: 10,
              ),
              AbsorbPointer(
                child: TextFieldContainerWidget(
                  controller: _emailController,
                  hintText: "email",
                  prefixIcon: Icons.person,
                  keyboardType: TextInputType.text,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFieldContainerWidget(
                controller: _phoneNumberController,
                hintText: "phone Number",
                prefixIcon: Icons.person,
                keyboardType: TextInputType.text,
              ),
              SizedBox(
                height: 20,
              ),

              InkWell(
                onTap: () {
                  _updateProfile();
                },
                child: Container(
                    margin: EdgeInsets.only(left: 22, right: 22),
                    alignment: Alignment.center,
                    height: 44,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Text(
                      'Update',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _updateProfile() {
    BlocProvider.of<UserCubit>(context).updateUser(
      user: UserEntity(
        uid: userData.uid,
        name: _nameController!.text,
        profileUrl: _profileUrl,
        phoneNumber: _phoneNumberController!.text,
      ),
    );

    BlocProvider.of<HistoryCubit>(context)
        .addNewEquipments(equipmentEntity: HistoryEntity(
      event: "Item has been Booked",
      actionDoneBy: "student(${_nameController!.text})",
      name: "${_nameController!.text}",
      time: Timestamp.now(),
    ));
    toast("Profile Updated");
  }


}
