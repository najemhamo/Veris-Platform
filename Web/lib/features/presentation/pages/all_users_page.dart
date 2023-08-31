import 'dart:io';
import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veris/const.dart';
import 'package:veris/features/domain/entities/equipment_entity.dart';
import 'package:veris/features/domain/entities/history_entity.dart';
import 'package:veris/features/domain/entities/user_entity.dart';
import 'package:veris/features/presentation/cubit/equipment/equipment_cubit.dart';
import 'package:veris/features/presentation/cubit/history/history_cubit.dart';
import 'package:veris/features/presentation/cubit/user/user_cubit.dart';
import 'package:veris/features/presentation/widgets/common/common.dart';
import 'package:veris/features/presentation/widgets/common/delete_alert_widget.dart';
import 'package:veris/features/presentation/widgets/common/equipment_photo_widget.dart';
import 'package:veris/features/presentation/widgets/common/search_widget.dart';
import 'package:veris/features/presentation/widgets/common/submit_button_widget.dart';
import 'package:veris/features/presentation/widgets/common/text_field_widget.dart';
import 'package:veris/features/presentation/widgets/nav_widgets/profile_image_widget.dart';
import 'package:veris/features/presentation/widgets/theme/style.dart';

class AllUsersPage extends StatefulWidget {
  final UserEntity user;
  const AllUsersPage({Key? key,required this.user}) : super(key: key);

  @override
  _AllUsersPageState createState() => _AllUsersPageState();
}

class _AllUsersPageState extends State<AllUsersPage> {



  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _statusController = TextEditingController();
  TextEditingController _searchController = TextEditingController();

  FirebaseStorage _storage = FirebaseStorage.instance;

  bool _isUploadingImage = false;
  int _isDeletedUsers = 0;


  String? _imageUrl;
  String? _imagePath;
  File? _pickedImage;
  int _availableGroupValue = 0;

  bool _isHover=false;

  @override
  void initState() {
    _searchController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _statusController.dispose();
    _searchController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit,UserState>(builder: (context, userState) {
      if (userState is UserLoaded) {
        final usersAdminData=userState.users.where((element) => widget.user.accountType==UserConst.admin?element.accountType==UserConst.student && widget.user.accountType==UserConst.admin:element.accountType==UserConst.student || element.accountType==UserConst.admin ).toList();
        final filteredUsers = usersAdminData.where((user) =>
        user.name!.startsWith(_searchController.text) ||
            user.name!.startsWith(_searchController.text) ||
            user.name!.toLowerCase().startsWith(_searchController.text.toLowerCase())
            ||   user.email!.startsWith(_searchController.text) ||
            user.email!.startsWith(_searchController.text) ||
            user.email!.toLowerCase().startsWith(_searchController.text.toLowerCase())
            ||   user.phoneNumber!.startsWith(_searchController.text) ||
            user.phoneNumber!.startsWith(_searchController.text) ||
            user.phoneNumber!.toLowerCase().startsWith(_searchController.text.toLowerCase())
            || user.email!.contains(_searchController.text)
            ||  user.name!.contains(_searchController.text)
            ||  user.phoneNumber!.contains(_searchController.text)
            || user.email!.toLowerCase().contains(_searchController.text.toLowerCase())
            ||  user.name!.toLowerCase().contains(_searchController.text.toLowerCase())
            ||  user.phoneNumber!.toLowerCase().contains(_searchController.text.toLowerCase())
        ).toList();


        final users=filteredUsers.where((user) => user.accountType!=UserConst.superAdmin && user.isDisable==false).toList();
        final deleteUsers=filteredUsers.where((user) =>user.isDisable==true).toList();


        return Column(
          children: [

            SearchWidget(
              searchHintText: "Search Users...",
              searchController: _searchController,
              onClearSearch: (){
                setState(() {
                  _searchController.clear();
                });
              },
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                Expanded(
                  child: _myRadioButton(
                    title: "All Users",
                    value: 0,
                    onChanged: (newValue) =>
                        setState(() {
                          _availableGroupValue = newValue!;
                        }),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: _myRadioButton(
                    title: "Deleted Users",
                    value: 1,
                    onChanged: (newValue) =>
                        setState(() {
                          _availableGroupValue = newValue!;
                        }),
                  ),
                ),
              ],
            ),
            _availableGroupValue==0?_allUsersBody(users):_allDeletedUsersBody(deleteUsers),
          ],
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



  Widget _allUsersBody(List<UserEntity> users){
    return Expanded(
      child: users.isEmpty?Center(child: Text("No Users added yet")):GridView.builder(
        itemCount: users.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: 1.2),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: (){
              _nameController.value=TextEditingValue(text: users[index].name!);
              _statusController.value = TextEditingValue(text: users[index].aboutMe!);
              _phoneNumberController.value = TextEditingValue(text: users[index].phoneNumber.toString());
              _emailController.value = TextEditingValue(text: users[index].email!);


              _showAlertDialog(users[index]);
            },
            child: Container(
              margin: EdgeInsets.all(8),
              child: Column(
                children: [
                  Container(
                    height: 140,
                    width: 140,
                    child: equipmentPhotoWidget(
                        imageUrl: users[index].profileUrl
                    ),
                  ),
                  SizedBox(height: 4,),
                  Text("${users[index].name}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                  SizedBox(height: 4,),
                  Text("${users[index].email}",maxLines: 5,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis,),
                  SizedBox(height: 4,),
                  Text("${users[index].phoneNumber}",maxLines: 5,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis,),
                  SizedBox(height: 4,),
                  Text("${users[index].accountType}",maxLines: 5,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis,),
                  SizedBox(height: 4,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SubmitButtonWidget(
                        text: "Update",
                        onTap: (){
                          _nameController.value=TextEditingValue(text: users[index].name!);
                          _statusController.value = TextEditingValue(text: users[index].aboutMe!);
                          _phoneNumberController.value = TextEditingValue(text: users[index].phoneNumber.toString());
                          _emailController.value = TextEditingValue(text: users[index].email!);
                          _showAlertDialog(users[index]);
                        },
                      ),
                      SizedBox(width: 10,),
                      SubmitButtonWidget(
                        text: "Delete",
                        onTap: (){
                          deleteUserAlertDialog(context,users[index]);
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  Widget _allDeletedUsersBody(List<UserEntity> users){
    return  Expanded(
      child: users.isEmpty?Center(child: Text("No Users added yet")):GridView.builder(
        itemCount: users.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: 1.2),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: (){
              _nameController.value=TextEditingValue(text: users[index].name!);
              _statusController.value = TextEditingValue(text: users[index].aboutMe!);
              _phoneNumberController.value = TextEditingValue(text: users[index].phoneNumber.toString());
              _emailController.value = TextEditingValue(text: users[index].email!);


              _showAlertDialog(users[index]);
            },
            child: Container(
              margin: EdgeInsets.all(8),
              child: Column(
                children: [
                  Container(
                    height: 140,
                    width: 140,
                    child: equipmentPhotoWidget(
                        imageUrl: users[index].profileUrl
                    ),
                  ),
                  SizedBox(height: 4,),
                  Text("${users[index].name}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                  SizedBox(height: 4,),
                  Text("${users[index].email}",maxLines: 5,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis,),
                  SizedBox(height: 4,),
                  Text("${users[index].phoneNumber}",maxLines: 5,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis,),
                  SizedBox(height: 4,),
                  Text("${users[index].accountType}",maxLines: 5,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis,),
                  SizedBox(height: 4,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SubmitButtonWidget(
                        text: "Update",
                        onTap: (){
                          _nameController.value=TextEditingValue(text: users[index].name!);
                          _statusController.value = TextEditingValue(text: users[index].aboutMe!);
                          _phoneNumberController.value = TextEditingValue(text: users[index].phoneNumber.toString());
                          _emailController.value = TextEditingValue(text: users[index].email!);
                          _showAlertDialog(users[index]);
                        },
                      ),
                      SizedBox(width: 10,),
                      SubmitButtonWidget(
                        text: "Recover",
                        onTap: (){
                          recoverUserAlertDialog(context,users[index]);
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  //FIXME:update equipment


  _showAlertDialog(UserEntity user) {

    // set up the button
    Widget okButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Update ${user.name}"),
      content:SingleChildScrollView(
        child: StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {

            return Container(
              width: MediaQuery.of(context).size.width/1.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10,),
                  _profileWidget(profile: user.profileUrl,setState: setState),
                  SizedBox(height: 10,),
                  TextFieldFullWidthWidget(
                    textName: 'Name',
                    hintTextName: 'Equipment Name',
                    textEditingController: _nameController,
                  ),
                  SizedBox(height: 10,),
                  TextFieldFullWidthWidget(
                    textName: 'phone number',
                    hintTextName: 'number',
                    textEditingController: _phoneNumberController,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  AbsorbPointer(
                    child: TextFieldFullWidthWidget(
                      textName: 'email',
                      hintTextName: '${user.email}',
                      textEditingController: _emailController,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFieldFullWidthWidget(
                    textName: 'Description',
                    hintTextName:
                    "description",
                    maxLine: 4,
                    textEditingController: _statusController,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SubmitButtonWidget(
                    width: 150,
                    text: "Update User",
                    onTap:(){
                      _submitUpdateUser(user.uid!);
                    },
                  ),
                ],
              ),
            );

          },
        ),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }




  void _submitUpdateUser(String uid) {
    BlocProvider.of<UserCubit>(context).updateUser(
        user: UserEntity(
          uid: uid,
          profileUrl: _imageUrl,
          phoneNumber: _phoneNumberController.text,
          aboutMe: _statusController.text,
          name: _nameController.text,
        ));

    BlocProvider.of<HistoryCubit>(context)
        .addNewEquipments(equipmentEntity: HistoryEntity(
      event: "User has been updated",
      actionDoneBy: "${widget.user.accountType}(${_nameController.text})",
      name: _nameController.text,
      time: Timestamp.now(),
    ));
    toast("${_nameController.text} Updated successfully");
  }


  Widget _profileWidget({String? profile = "", bool isColor = false,required void Function(void Function()) setState}) {
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
            _startFilePicker(setState);
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
                : profileImageWidget(imageUrl: _imageUrl==null?profile:_imageUrl),
          ),
        ),
      ],
    );
  }


  _startFilePicker(void Function(void Function()) setState) async {
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
            .child("equipments/${DateTime.now().microsecondsSinceEpoch}.png");

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

  Widget _myRadioButton(
      {required String title,
        required int value,
        required Function(int? value) onChanged}) {
    return Container(
      child: RadioListTile(
        value: value,
        groupValue: _availableGroupValue,
        onChanged: onChanged,
        title: Text(title),
      ),
    );
  }

}
