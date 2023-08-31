

import 'dart:io';
import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veris/features/domain/entities/equipment_entity.dart';
import 'package:veris/features/presentation/cubit/equipment/equipment_cubit.dart';
import 'package:veris/features/presentation/widgets/common/common.dart';
import 'package:veris/features/presentation/widgets/common/submit_button_widget.dart';
import 'package:veris/features/presentation/widgets/common/text_field_widget.dart';
import 'package:veris/features/presentation/widgets/nav_widgets/profile_image_widget.dart';
import 'package:veris/features/presentation/widgets/theme/style.dart';

class AddNewEquipmentAlertDialogWidget extends StatefulWidget {
  const AddNewEquipmentAlertDialogWidget({Key? key}) : super(key: key);

  @override
  _AddNewEquipmentAlertDialogWidgetState createState() => _AddNewEquipmentAlertDialogWidgetState();
}

class _AddNewEquipmentAlertDialogWidgetState extends State<AddNewEquipmentAlertDialogWidget> {



  TextEditingController _equipmentNameController = TextEditingController();
  TextEditingController _shelfController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  FirebaseStorage _storage = FirebaseStorage.instance;

  bool _isUploadingImage = false;
  String? _imageUrl;
  String? _imagePath;
  File? _pickedImage;
  int _availableGroupValue = -1;

  bool _isHover=false;

  @override
  void dispose() {
    _equipmentNameController.dispose();
    _shelfController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (value){
        setState(() {
          _isHover=value;
        });
      },
      onTap: (){
        _showAlertDialog();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        decoration: BoxDecoration(
          color: _isHover == true ? color583BD1.withOpacity(.2) : color583BD1,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Text(
              "Add equipment",
              style: TextStyle(color: _isHover == true?Colors.black:Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  _showAlertDialog() {

    // set up the button
    Widget okButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Add New Equipment"),
      content:SingleChildScrollView(
        child: StatefulBuilder(

          builder: (BuildContext context, void Function(void Function()) setState) {

            return Container(
              width: MediaQuery.of(context).size.width/1.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10,),
                  _profileWidget(setState: setState),
                  SizedBox(height: 10,),
                  TextFieldFullWidthWidget(
                    textName: 'Name',
                    hintTextName: 'Equipment Name',
                    textEditingController: _equipmentNameController,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFieldFullWidthWidget(
                    textName: 'Shelf',
                    hintTextName: 'Shelf equipment that are displayed ',
                    textEditingController: _shelfController,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFieldFullWidthWidget(
                    textName: 'quantity',
                    hintTextName: 'equipment quantity e.g 1 or 10',
                    textEditingController: _quantityController,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  _isAvailable(setState),
                  SizedBox(
                    height: 15,
                  ),
                  TextFieldFullWidthWidget(
                    textName: 'Description',
                    hintTextName:
                    "Here you can write some information about the product.",
                    maxLine: 4,
                    textEditingController: _descriptionController,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SubmitButtonWidget(
                    width: 150,
                    text: "Add new Equipment",
                    onTap: _submitNewEquipment,
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


  Widget _isAvailable(void Function(void Function()) setState) {
    return Row(
      children: [
        Expanded(
          child: Text(
            "Available",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: _myRadioButton(
            title: "Yes",
            value: 1,
            onChanged: (newValue) =>
                setState(() => _availableGroupValue = newValue!),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: _myRadioButton(
            title: "No",
            value: 0,
            onChanged: (newValue) =>
                setState(() => _availableGroupValue = newValue!),
          ),
        ),
      ],
    );
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



  void _submitNewEquipment() {
    if (_equipmentNameController.text.isEmpty) {
      toast("Enter Equipment name");
      return;
    }
    if (_shelfController.text.isEmpty) {
      toast("Enter shelf");
      return;
    }
    if (_quantityController.text.isEmpty) {
      toast("Enter quantity");
      return;
    }

    if (_availableGroupValue==-1){
      toast("Select availability");
      return;
    }
    if (_imageUrl==null) {
      toast("Select Equipment Image");
      return;
    }
    BlocProvider.of<EquipmentCubit>(context).addNewEquipments(
        equipmentEntity: EquipmentEntity(
          totalAvailableEquipment: 0,
          shelf: _shelfController.text,
          queue: [],
          waitingQueue: [],
          pickupEquipmentTime: [],
          quantity: int.parse(_quantityController.text),
          pickupEquipment: false,
          createdTime: Timestamp.now(),
          isAvailable: _availableGroupValue.toString(),
          equipmentPhoto: _imageUrl,
          description: _descriptionController.text,
          name: _equipmentNameController.text,
          pickQueue: [],
          waitingQueueId: [],
        ));
    _clear();
    toast("New Equipment Added successfully");
  }

  void _clear() {
    setState(() {
      _equipmentNameController.clear();
      _shelfController.clear();
      _quantityController.clear();
      _descriptionController.clear();
      _imageUrl = null;
      _availableGroupValue=-1;
    });
  }

  Widget _profileWidget({String? profile = "", bool isColor = false,required void Function(void Function()) setState}) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Text("Equipment Picture"),
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
                : profileImageWidget(imageUrl: _imageUrl),
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
}
