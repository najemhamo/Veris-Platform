import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veris/features/domain/entities/equipment_entity.dart';
import 'package:veris/features/domain/entities/history_entity.dart';
import 'package:veris/features/domain/entities/user_entity.dart';
import 'package:veris/features/presentation/cubit/credential/credential_cubit.dart';
import 'package:veris/features/presentation/cubit/equipment/equipment_cubit.dart';
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

class EquipmentPage extends StatefulWidget {
  final UserEntity user;
  const EquipmentPage({Key? key,required this.user}) : super(key: key);

  @override
  _EquipmentPageState createState() => _EquipmentPageState();
}

class _EquipmentPageState extends State<EquipmentPage> {
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
                    _isAvailable(),
                    SizedBox(
                      height: 15,
                    ),
                    TextFieldFullWidthWidget(
                      textName: 'Description',
                      hintTextName:
                          "Here you can write some information about the product.",
                      maxLine: 8,
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
        Text("Equipment Picture"),
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
          quantity: int.parse(_quantityController.text),
          pickupEquipment: false,
          createdTime: Timestamp.now(),
          isAvailable: _availableGroupValue.toString(),
          equipmentPhoto: _imageUrl,
          description: _descriptionController.text,
          name: _equipmentNameController.text,
          waitingQueueId: [],
          pickQueue: [],
          waitingQueue: [],
          pickupEquipmentTime: [],

    ));
    BlocProvider.of<HistoryCubit>(context)
        .addNewEquipments(equipmentEntity: HistoryEntity(
      event: "Item has been added",
      actionDoneBy: "${widget.user.accountType}",
      name: _equipmentNameController.text,
      time: Timestamp.now(),
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

  Widget _isAvailable() {
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
}
