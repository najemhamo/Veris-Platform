import 'dart:io';
import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:veris/features/data/remote/models/user_model.dart';
import 'package:veris/features/domain/entities/equipment_entity.dart';
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

class EquipmentsReportPage extends StatefulWidget {
  const EquipmentsReportPage({Key? key}) : super(key: key);

  @override
  _EquipmentsReportPageState createState() => _EquipmentsReportPageState();
}

class _EquipmentsReportPageState extends State<EquipmentsReportPage> {
  TextStyle _tableHeaderStyle = TextStyle(color: Colors.black, fontSize: 14.0);
  TextStyle _tableHeader1Style = TextStyle(color: Colors.white, fontSize: 14.0);

  TextEditingController _equipmentNameController = TextEditingController();
  TextEditingController _shelfController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _searchController = TextEditingController();

  FirebaseStorage _storage = FirebaseStorage.instance;

  bool _isUploadingImage = false;
  String? _imageUrl;
  String? _imagePath;
  File? _pickedImage;
  int _availableGroupValue = -1;

  bool _isHover = false;

  @override
  void initState() {
    BlocProvider.of<HistoryCubit>(context).getHistories();
    _searchController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _equipmentNameController.dispose();
    _shelfController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, historyState) {
      if (historyState is HistoryLoaded) {
        final filteredEquipment = historyState.historyData
            .where(
              (ep) =>
                  ep.name!.startsWith(_searchController.text) ||
                  ep.name!.startsWith(_searchController.text) ||
                  ep.name!
                      .toLowerCase()
                      .startsWith(_searchController.text.toLowerCase()) ||
                  ep.actionDoneBy!.startsWith(_searchController.text) ||
                  ep.actionDoneBy!.startsWith(_searchController.text) ||
                  ep.actionDoneBy!
                      .toLowerCase()
                      .startsWith(_searchController.text.toLowerCase()) ||
                  ep.event!.startsWith(_searchController.text) ||
                  ep.event!.startsWith(_searchController.text) ||
                  ep.event!
                      .toLowerCase()
                      .startsWith(_searchController.text.toLowerCase()) ||
                  ep.event!.contains(_searchController.text) ||
                  ep.name!.contains(_searchController.text) ||
                  ep.actionDoneBy!.contains(_searchController.text)
              ||   ep.event!.toLowerCase().contains(_searchController.text.toLowerCase()) ||
                      ep.name!.toLowerCase().contains(_searchController.text.toLowerCase()) ||
                      ep.actionDoneBy!.toLowerCase().contains(_searchController.text.toLowerCase())

          ,
            )
            .toList();

        // final filteredEquipment = reportEquipments
        //     .where((ep) =>
        //         ep.name!.startsWith(_searchController.text) ||
        //         ep.name!.startsWith(_searchController.text) ||
        //         ep.name!
        //             .toLowerCase()
        //             .startsWith(_searchController.text.toLowerCase()))
        //     .toList();

        return Column(
          children: [
            SearchWidget(
              searchHintText: "Search Historical reports...",
              searchController: _searchController,
              onClearSearch: () {
                setState(() {
                  _searchController.clear();
                });
              },
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.only(right: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Table(
                      defaultColumnWidth: FixedColumnWidth(180.0),
                      border: TableBorder(
                        left: BorderSide(
                            color: Colors.black,
                            style: BorderStyle.solid,
                            width: 2),
                        right: BorderSide(
                            color: Colors.black,
                            style: BorderStyle.solid,
                            width: 2),
                        top: BorderSide(
                            color: Colors.black,
                            style: BorderStyle.solid,
                            width: 2),
                        horizontalInside: BorderSide(
                            color: Colors.black,
                            style: BorderStyle.solid,
                            width: 2),
                        verticalInside: BorderSide(
                            color: Colors.black,
                            style: BorderStyle.solid,
                            width: 2),
                      ),
                      children: [
                        TableRow(
                            decoration: BoxDecoration(
                              color: Colors.black,
                            ),
                            children: [
                              Column(children: [
                                Text('Name', style: _tableHeader1Style)
                              ]),
                              Column(children: [
                                Text('Event', style: _tableHeader1Style)
                              ]),
                              Column(children: [
                                Text('User',
                                    style: _tableHeader1Style)
                              ]),
                              Column(children: [
                                Text('Date', style: _tableHeader1Style)
                              ]),
                            ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: filteredEquipment.isEmpty
                  ? Center(child: Text("No History Report found"))
                  : ListView.builder(
                      itemCount: filteredEquipment.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(right: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: Table(
                                  defaultColumnWidth: FixedColumnWidth(180.0),
                                  border: TableBorder(
                                    left: BorderSide(
                                        color: Colors.black,
                                        style: BorderStyle.solid,
                                        width: 2),
                                    right: BorderSide(
                                        color: Colors.black,
                                        style: BorderStyle.solid,
                                        width: 2),
                                    top: BorderSide(
                                        color: Colors.black,
                                        style: BorderStyle.solid,
                                        width: 2),
                                    horizontalInside: BorderSide(
                                        color: Colors.black,
                                        style: BorderStyle.solid,
                                        width: 2),
                                    verticalInside: BorderSide(
                                        color: Colors.black,
                                        style: BorderStyle.solid,
                                        width: 2),
                                    bottom: index == filteredEquipment.length
                                        ? BorderSide(
                                            color: Colors.black,
                                            style: BorderStyle.solid,
                                            width: 2)
                                        : BorderSide(
                                            color: Colors.black,
                                            style: BorderStyle.solid,
                                            width: 0),
                                  ),
                                  children: [
                                    TableRow(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(4),
                                            child: Column(children: [
                                              Text(
                                                  '${filteredEquipment[index].name}',
                                                  style: _tableHeaderStyle),
                                            ]),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(4),
                                            child: Column(children: [
                                              Text(
                                                  '${filteredEquipment[index].event}',
                                                  style: _tableHeaderStyle)
                                            ]),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(4),
                                            child: Column(children: [
                                              Text(
                                                  '${filteredEquipment[index].actionDoneBy}',
                                                  style: _tableHeaderStyle)
                                            ]),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(4),
                                            child: Column(children: [
                                              Text(
                                                  '${DateFormat("dd/MMM/yyy hh:mm a").format(filteredEquipment[index].time!.toDate())}',
                                                  style: _tableHeaderStyle)
                                            ]),
                                          ),
                                        ]),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            )
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

  //FIXME:update equipment

  _showAlertDialog(EquipmentEntity equipment) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Details ${equipment.name}"),
      content: SingleChildScrollView(
        child: StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            return Container(
              width: MediaQuery.of(context).size.width / 1.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  _profileWidget(
                      profile: equipment.equipmentPhoto, setState: setState),
                  SizedBox(
                    height: 10,
                  ),
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
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Equipment Hold",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  BlocBuilder<UserCubit, UserState>(
                      builder: (context, userState) {
                    if (userState is UserLoaded) {
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: equipment.pickQueue!.length,
                          itemBuilder: (context, index) {
                            final user = userState.users.firstWhere(
                                (element) =>
                                    element.uid == equipment.queue![index],
                                orElse: () => UserModel());
                            return Row(
                              children: [
                                Container(
                                  height: 54,
                                  width: 54,
                                  child: profileImageWidget(
                                      imageUrl: user.profileUrl),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          child: Text("${user.name}"),
                                        ),
                                        Container(
                                          child: Text(
                                              "${DateFormat("dd MMM yyy hh:mm a").format((equipment.pickQueue![index]['time'] as Timestamp).toDate())}"),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Container(
                                      child: Text("${user.email}"),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          });
                    }

                    return CircularProgressIndicator();
                  }),
                  equipment.waitingQueue!.isNotEmpty
                      ? Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Waiting Queue",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ))
                      : Text(""),
                  SizedBox(
                    height: 10,
                  ),
                  BlocBuilder<UserCubit, UserState>(
                      builder: (context, userState) {
                    if (userState is UserLoaded) {
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: equipment.waitingQueue!.length,
                          itemBuilder: (context, index) {
                            final user = userState.users.firstWhere(
                                (element) =>
                                    element.uid ==
                                    equipment.waitingQueueId![index],
                                orElse: () => UserModel());
                            return Row(
                              children: [
                                Container(
                                  height: 54,
                                  width: 54,
                                  child: profileImageWidget(
                                      imageUrl: user.profileUrl),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Text("${user.name}"),
                                          ),
                                          Container(
                                            child: Text(
                                                "${DateFormat("dd/MMMM/yyy - hh:mm a").format((equipment.waitingQueue![index]['time'] as Timestamp).toDate())}"),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Text("${user.email}"),
                                          ),
                                          TextButton(
                                            child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 4, vertical: 2),
                                                decoration: BoxDecoration(
                                                  border: Border.all(width: 1),
                                                ),
                                                child: Text("Assign")),
                                            onPressed: () {
                                              toast(
                                                  "${equipment.name} assign to user ${user.name}");
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          });
                    }

                    return CircularProgressIndicator();
                  }),
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

  void _submitUpdateEquipment(String equipmentId) {
    BlocProvider.of<EquipmentCubit>(context).updateEquipments(
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
      equipmentId: equipmentId,
    ));
    toast("${_equipmentNameController.text} Updated successfully");
  }

  Widget _profileWidget(
      {String? profile = "",
      bool isColor = false,
      required void Function(void Function()) setState}) {
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
                : profileImageWidget(
                    imageUrl: _imageUrl == null ? profile : _imageUrl),
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
