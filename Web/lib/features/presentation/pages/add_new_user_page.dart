import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veris/features/domain/entities/history_entity.dart';
import 'package:veris/features/domain/entities/user_entity.dart';
import 'package:veris/features/presentation/cubit/credential/credential_cubit.dart';
import 'package:veris/features/presentation/cubit/history/history_cubit.dart';
import 'package:veris/features/presentation/widgets/common/common.dart';
import 'package:veris/features/presentation/widgets/common/drop_down_widget.dart';
import 'package:veris/features/presentation/widgets/common/password_container_widget.dart';
import 'package:veris/features/presentation/widgets/common/submit_button_widget.dart';
import 'dart:html' as html;
import 'package:veris/features/presentation/widgets/common/text_field_widget.dart';
import 'package:veris/features/presentation/widgets/nav_widgets/profile_image_widget.dart';
import 'package:veris/features/presentation/widgets/theme/style.dart';

import '../../../const.dart';

class AddNewUserPage extends StatefulWidget {
  final UserEntity user;
  const AddNewUserPage({Key? key,required this.user}) : super(key: key);

  @override
  _AddNewUserPageState createState() => _AddNewUserPageState();
}

class _AddNewUserPageState extends State<AddNewUserPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _statusController = TextEditingController();
  FirebaseStorage _storage = FirebaseStorage.instance;

  bool _isUploadingImage = false;
  String? _imageUrl;
  String? _imagePath;
  File? _pickedImage;
  String _userAccountType = "";

  @override
  void dispose() {
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 50, right: 150, top: 30),
      child: ListView(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFieldFullWidthWidget(
                      textName: 'Name',
                      hintTextName: 'username',
                      textEditingController: _nameController,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFieldFullWidthWidget(
                      textName: 'Phone Number',
                      hintTextName: 'Number',
                      textEditingController: _phoneNumberController,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFieldFullWidthWidget(
                      textName: 'Email',
                      hintTextName: 'example@gmail.com',
                      textEditingController: _emailController,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    PasswordContainerWidget(
                      controller: _passwordController,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    DropDownWidget(
                    //  userTypes: widget.user.accountType==UserConst.superAdmin?UserConst.superAdminTypes:UserConst.admin,
                      userTypeCallBack: (String type) {
                        setState(() {
                          _userAccountType = type;
                        });
                      }, userTypes: widget.user.accountType==UserConst.superAdmin?UserConst.superAdminTypes:UserConst.adminTypes,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFieldFullWidthWidget(
                      textName: 'Bio',
                      hintTextName:
                          "Please write anything about yourself.",
                      maxLine: 8,
                      textEditingController: _statusController,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SubmitButtonWidget(
                      width: 140,
                      text: "Create New User",
                      onTap: _submitNewUser,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 50,
              ),
              _profileWidget()
            ],
          ),
        ],
      ),
    );
  }

  Widget _profileWidget({String? profile = "", bool isColor = false}) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Text("Profile Picture"),
        SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () async {
            _startFilePicker();
          },
          child: Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              color:
                  isColor == false ? Colors.grey.withOpacity(.4) : color583BD1,
            ),
            child: _isUploadingImage == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : profileImageWidget(imageUrl: _imageUrl),
          ),
        ),
      ],
    );
  }

  _startFilePicker() async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement()
      ..accept = "image/*";
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      // read file content as dataURL
      final file = uploadInput.files!.first;
      final reader = html.FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) async {
        setState(() {
          _isUploadingImage = true;
        });
        final ref = _storage
            .ref()
            .child("images/${DateTime.now().microsecondsSinceEpoch}.png");

        print(ref.fullPath);

        final uploadTask = ref.putBlob(file);
        print("bytes transf :${uploadTask.snapshot.bytesTransferred}");
        if (uploadTask.snapshot.totalBytes ==
            uploadTask.snapshot.bytesTransferred) {
          toast("Image updated");
        }

        final url = (await uploadTask.whenComplete(() {
          print("uploaded success fully");
          setState(() {
            _isUploadingImage = false;
          });
        }))
            .ref
            .getDownloadURL();

        final urlImage = await url;
        setState(() {
          _imageUrl = urlImage;
        });
        toast("Image Picked Successfully");
        print("url ${await url}");
      });
    });
  }

  void _submitNewUser() {
    if (_nameController.text.isEmpty) {
      toast("Enter name");
      return;
    }
    if (_emailController.text.isEmpty) {
      toast("Enter email");
      return;
    }
    if (_passwordController.text.isEmpty) {
      toast("Enter email");
      return;
    }
    if (_userAccountType == "") {
      toast("Select user type");
      return;
    }

    BlocProvider.of<CredentialCubit>(context).submitNewUser(
        user: UserEntity(
      accountType: _userAccountType,
      password: _passwordController.text,
      aboutMe: _statusController.text,
      profileUrl: _imageUrl,
      phoneNumber: _phoneNumberController.text,
      email: _emailController.text,
      name: _nameController.text,
      deviceToken: "",
    ));

    BlocProvider.of<HistoryCubit>(context)
        .addNewEquipments(equipmentEntity: HistoryEntity(
      event: "New User has been Created",
      actionDoneBy: "${widget.user.accountType}(${_nameController.text})",
      name: _nameController.text,
      time: Timestamp.now(),
    ));
    _clear();
    toast("New user created successfully");
  }

  void _clear() {
    setState(() {
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _statusController.clear();
      _imageUrl = null;
    });
  }
}
