import 'dart:io';
import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:veris/features/data/remote/models/pick_item_queue_data.dart';
import 'package:veris/features/data/remote/models/user_model.dart';
import 'package:veris/features/domain/entities/equipment_entity.dart';
import 'package:veris/features/domain/entities/history_entity.dart';
import 'package:veris/features/domain/entities/user_entity.dart';
import 'package:veris/features/presentation/cubit/equipment/equipment_cubit.dart';
import 'package:veris/features/presentation/cubit/history/history_cubit.dart';
import 'package:veris/features/presentation/cubit/user/user_cubit.dart';
import 'package:veris/features/presentation/s_pages/widets/s_submit_button_widget.dart';
import 'package:veris/features/presentation/widgets/common/common.dart';
import 'package:veris/features/presentation/widgets/common/delete_alert_widget.dart';
import 'package:veris/features/presentation/widgets/common/equipment_photo_widget.dart';
import 'package:veris/features/presentation/widgets/common/search_widget.dart';
import 'package:veris/features/presentation/widgets/common/submit_button_widget.dart';
import 'package:veris/features/presentation/widgets/common/text_field_widget.dart';
import 'package:veris/features/presentation/widgets/nav_widgets/profile_image_widget.dart';
import 'package:veris/features/presentation/widgets/theme/style.dart';

class SGetAllEquipments extends StatefulWidget {
  final UserEntity user;

  const SGetAllEquipments({Key? key, required this.user}) : super(key: key);

  @override
  _SGetAllEquipmentsState createState() => _SGetAllEquipmentsState();
}

class _SGetAllEquipmentsState extends State<SGetAllEquipments> {
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
  void dispose() {
    _equipmentNameController.dispose();
    _shelfController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    BlocProvider.of<EquipmentCubit>(context).getEquipments();

    _searchController.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EquipmentCubit, EquipmentState>(
        builder: (context, equipmentState) {
      if (equipmentState is EquipmentLoaded) {
        final filteredEquipment = equipmentState.equipments
            .where((ep) =>
                ep.name!.startsWith(_searchController.text) ||
                ep.name!.startsWith(_searchController.text) ||
                ep.name!
                    .toLowerCase()
                    .startsWith(_searchController.text.toLowerCase()) ||
                ep.description!.startsWith(_searchController.text) ||
                ep.description!.startsWith(_searchController.text) ||
                ep.description!
                    .toLowerCase()
                    .startsWith(_searchController.text.toLowerCase())
              || ep.description!.startsWith(_searchController.text)
              || ep.name!.startsWith(_searchController.text)

          ,)
            .toList();

        return Column(
          children: [
            SearchWidget(
              searchHintText: "Search Equipments...",
              searchController: _searchController,
              onClearSearch: () {
                print(filteredEquipment.length);
                print(_searchController.text);
                setState(() {
                  _searchController.clear();
                });
              },
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: filteredEquipment.isEmpty
                  ? Center(child: Text("No Equipment added yet"))
                  : GridView.builder(
                      itemCount: filteredEquipment.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, childAspectRatio: 1.2),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            _equipmentNameController.value = TextEditingValue(
                                text: filteredEquipment[index].name!);
                            _shelfController.value = TextEditingValue(
                                text: filteredEquipment[index].shelf!);
                            _quantityController.value = TextEditingValue(
                                text: filteredEquipment[index]
                                    .quantity
                                    .toString());
                            _descriptionController.value = TextEditingValue(
                                text: filteredEquipment[index].description!);

                            _showAlertDialog(filteredEquipment[index]);
                          },
                          child: Container(
                            margin: EdgeInsets.all(8),
                            child: Column(
                              children: [
                                Container(
                                  height: 140,
                                  width: 140,
                                  child: equipmentPhotoWidget(
                                      imageUrl: filteredEquipment[index]
                                          .equipmentPhoto),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "${filteredEquipment[index].name}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "${filteredEquipment[index].description}",
                                  maxLines: 5,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SSubmitButtonWidget(
                                      color: filteredEquipment[index]
                                                  .queue!
                                                  .length ==
                                              filteredEquipment[index].quantity!
                                          ? filteredEquipment[index]
                                                  .waitingQueueId!
                                                  .contains(widget.user.uid)
                                              ? color583BD1.withOpacity(.2)
                                              : color583BD1
                                          : filteredEquipment[index]
                                                  .queue!
                                                  .contains(widget.user.uid)
                                              ? color583BD1.withOpacity(.2)
                                              : color583BD1,
                                      text: filteredEquipment[index]
                                                  .queue!
                                                  .length ==
                                              filteredEquipment[index].quantity!
                                          ? filteredEquipment[index]
                                                  .waitingQueueId!
                                                  .contains(widget.user.uid)
                                              ? "Booked"
                                              : "Book"
                                          : "Pickup",
                                      onTap: filteredEquipment[index]
                                              .pickQueue!
                                              .contains(widget.user.uid) ||
                                          filteredEquipment[index].waitingQueueId!.contains(widget.user.uid)
                                          ? null
                                          : () {
                                              print(filteredEquipment[index]
                                                  .queue!
                                                  .length);
                                              if (filteredEquipment[index]
                                                      .queue!
                                                      .length ==
                                                  filteredEquipment[index]
                                                      .quantity!) {
                                                if (filteredEquipment[index]
                                                    .waitingQueueId!
                                                    .contains(
                                                        widget.user.uid)) {
                                                  return;
                                                }

                                                toast(
                                                    "${filteredEquipment[index].name} not available yet.");

                                                if (filteredEquipment[index]
                                                    .waitingQueueId!
                                                    .contains(
                                                        widget.user.uid)) {
                                                  BlocProvider.of<
                                                              EquipmentCubit>(
                                                          context)
                                                      .getRemoveForWaitingEquipments(
                                                          pickItemQueueData:
                                                              PickItemQueueData(
                                                                  uid: widget
                                                                      .user.uid,
                                                                  equipmentId:
                                                                      filteredEquipment[
                                                                              index]
                                                                          .equipmentId,
                                                                  time: Timestamp
                                                                      .now()));
                                                  Future.delayed(
                                                      Duration(seconds: 1), () {
                                                    toast(
                                                        "${filteredEquipment[index].name} Remove From Waiting Queue.");
                                                  });
                                                  return;
                                                } else {
                                                  BlocProvider.of<
                                                              EquipmentCubit>(
                                                          context)
                                                      .getWaitingForEquipments(
                                                          pickItemQueueData:
                                                              PickItemQueueData(
                                                                  uid: widget
                                                                      .user.uid,
                                                                  equipmentId:
                                                                      filteredEquipment[
                                                                              index]
                                                                          .equipmentId,
                                                                  time: Timestamp
                                                                      .now()));
                                                  Future.delayed(
                                                      Duration(seconds: 1), () {
                                                    toast(
                                                        "${filteredEquipment[index].name} Added In Waiting Queue.");
                                                  });
                                                }
                                                BlocProvider.of<HistoryCubit>(
                                                        context)
                                                    .addNewEquipments(
                                                        equipmentEntity:
                                                            HistoryEntity(
                                                  event: "Item has been Booked",
                                                  actionDoneBy:
                                                      "${widget.user.accountType}(${widget.user.name})",
                                                  name: filteredEquipment[index]
                                                      .name,
                                                  time: Timestamp.now(),
                                                ));
                                                return;
                                              }

                                              if (filteredEquipment[index]
                                                  .queue!
                                                  .contains(widget.user.uid)) {
                                                return;
                                              } else {
                                                BlocProvider.of<EquipmentCubit>(
                                                        context)
                                                    .getPickUpEquipments(
                                                  pickItemQueueData:
                                                      PickItemQueueData(
                                                          uid: widget.user.uid,
                                                          equipmentId:
                                                              filteredEquipment[
                                                                      index]
                                                                  .equipmentId,
                                                          time:
                                                              Timestamp.now()),
                                                );
                                                BlocProvider.of<HistoryCubit>(
                                                        context)
                                                    .addNewEquipments(
                                                        equipmentEntity:
                                                            HistoryEntity(
                                                  event:
                                                      "Item has been pickedup",
                                                  actionDoneBy:
                                                      "${widget.user.accountType}(${widget.user.name})",
                                                  name: filteredEquipment[index]
                                                      .name,
                                                  time: Timestamp.now(),
                                                ));
                                              }
                                            },
                                    ),
                                    SSubmitButtonWidget(
                                      color: !filteredEquipment[index]
                                              .queue!
                                              .contains(widget.user.uid)
                                          ? color583BD1.withOpacity(.2)
                                          : color583BD1,
                                      text: "Return",
                                      onTap: !filteredEquipment[index]
                                              .queue!
                                              .contains(widget.user.uid)
                                          ? null
                                          : () {
                                              BlocProvider.of<EquipmentCubit>(
                                                      context)
                                                  .getDropEquipments(
                                                pickItemQueueData:
                                                    PickItemQueueData(
                                                        uid: widget.user.uid,
                                                        equipmentId:
                                                            filteredEquipment[
                                                                    index]
                                                                .equipmentId,
                                                        time: Timestamp.now()),
                                              );
                                              BlocProvider.of<HistoryCubit>(
                                                      context)
                                                  .addNewEquipments(
                                                      equipmentEntity:
                                                          HistoryEntity(
                                                event: "Item has been returned",
                                                actionDoneBy:
                                                    "${widget.user.accountType}(${widget.user.name})",
                                                name: filteredEquipment[index]
                                                    .name,
                                                time: Timestamp.now(),
                                              ));
                                            },
                                    ),
                                  ],
                                )
                              ],
                            ),
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
      title: Text("Update ${equipment.name}"),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Total Equipment :",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Text("${equipment.quantity}")
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Total Available:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Text(
                              "${(equipment.quantity!.toInt() - equipment.queue!.length.toInt())}")
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  equipment.queue!.isNotEmpty
                      ? Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Equipment Hold",
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
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SSubmitButtonWidget(
                        color: equipment.queue!.length == equipment.quantity!
                            ? equipment.waitingQueueId!
                                    .contains(widget.user.uid)
                                ? color583BD1.withOpacity(.2)
                                : color583BD1
                            : equipment.queue!.contains(widget.user.uid)
                                ? color583BD1.withOpacity(.2)
                                : color583BD1,
                        text: equipment.queue!.length == equipment.quantity!
                            ? equipment.waitingQueueId!
                                    .contains(widget.user.uid)
                                ? "Booked"
                                : "Book"
                            : "Pickup",
                        onTap: equipment.pickQueue!.contains(widget.user.uid) ||
                            equipment.waitingQueueId!.contains(widget.user.uid)
                            ? null
                            : () {
                                print(equipment.queue!.length);
                                if (equipment.queue!.length ==
                                    equipment.quantity!) {


                                  if (equipment.waitingQueueId!
                                      .contains(widget.user.uid)){
                                    return;
                                  }
                                  toast("${equipment.name} not available yet.");

                                  if (equipment.waitingQueueId!
                                      .contains(widget.user.uid)) {
                                    BlocProvider.of<EquipmentCubit>(context)
                                        .getRemoveForWaitingEquipments(
                                            pickItemQueueData:
                                                PickItemQueueData(
                                                    uid: widget.user.uid,
                                                    equipmentId:
                                                        equipment.equipmentId,
                                                    time: Timestamp.now()));
                                    Future.delayed(Duration(seconds: 1), () {
                                      toast(
                                          "${equipment.name} Remove From Waiting Queue.");
                                    });
                                    Navigator.pop(context);
                                    return;
                                  } else {
                                    BlocProvider.of<EquipmentCubit>(context)
                                        .getWaitingForEquipments(
                                            pickItemQueueData:
                                                PickItemQueueData(
                                                    uid: widget.user.uid,
                                                    equipmentId:
                                                        equipment.equipmentId,
                                                    time: Timestamp.now()));
                                    toast(
                                        "${equipment.name} Added In Waiting Queue.");
                                    BlocProvider.of<HistoryCubit>(context)
                                        .addNewEquipments(
                                            equipmentEntity: HistoryEntity(
                                      event: "Item has been Booked",
                                      actionDoneBy:
                                          "${widget.user.accountType}(${widget.user.name})",
                                      name: equipment.name,
                                      time: Timestamp.now(),
                                    ));
                                  }
                                  Navigator.pop(context);
                                  return;
                                }

                                if (equipment.queue!
                                    .contains(widget.user.uid)) {
                                  Navigator.pop(context);
                                  return;
                                } else {
                                  BlocProvider.of<EquipmentCubit>(context)
                                      .getPickUpEquipments(
                                    pickItemQueueData: PickItemQueueData(
                                        uid: widget.user.uid,
                                        equipmentId: equipment.equipmentId,
                                        time: Timestamp.now()),
                                  );
                                  BlocProvider.of<HistoryCubit>(context)
                                      .addNewEquipments(
                                          equipmentEntity: HistoryEntity(
                                    event: "Item has been pickedup",
                                    actionDoneBy:
                                        "${widget.user.accountType}(${widget.user.name})",
                                    name: equipment.name,
                                    time: Timestamp.now(),
                                  ));
                                }
                                Navigator.pop(context);
                              },
                      ),
                      SSubmitButtonWidget(
                        color: !equipment.queue!.contains(widget.user.uid)
                            ? color583BD1.withOpacity(.2)
                            : color583BD1,
                        text: "Return",
                        onTap: !equipment.queue!.contains(widget.user.uid)
                            ? null
                            : () {
                                BlocProvider.of<EquipmentCubit>(context)
                                    .getDropEquipments(
                                  pickItemQueueData: PickItemQueueData(
                                      uid: widget.user.uid,
                                      equipmentId: equipment.equipmentId,
                                      time: Timestamp.now()),
                                );
                                BlocProvider.of<HistoryCubit>(context)
                                    .addNewEquipments(
                                        equipmentEntity: HistoryEntity(
                                  event: "Item has been returned",
                                  actionDoneBy:
                                      "${widget.user.accountType}(${widget.user.name})",
                                  name: equipment.name,
                                  time: Timestamp.now(),
                                ));
                                Navigator.pop(context);
                              },
                      ),
                    ],
                  )
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
