

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veris/features/domain/entities/equipment_entity.dart';
import 'package:veris/features/domain/entities/history_entity.dart';
import 'package:veris/features/domain/entities/user_entity.dart';
import 'package:veris/features/presentation/cubit/equipment/equipment_cubit.dart';
import 'package:veris/features/presentation/cubit/history/history_cubit.dart';
import 'package:veris/features/presentation/cubit/user/user_cubit.dart';





recoverUserAlertDialog(BuildContext context,UserEntity user) {
  // set up the button
  Widget cancelButton = TextButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget yesButton = TextButton(
    child: Text("Yes"),
    onPressed: () {
      BlocProvider.of<UserCubit>(context).updateUser(
        user: user,
      );
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Recover ${user.name}"),
    content: Text("Are you sure you want to recover ${user.name}?"),
    actions: [
      cancelButton,
      yesButton
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


deleteUserAlertDialog(BuildContext context,UserEntity user) {
  // set up the button
  Widget cancelButton = TextButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget yesButton = TextButton(
    child: Text("Yes"),
    onPressed: () {

      //FIXME:continue updating
      BlocProvider.of<UserCubit>(context).updateUser(
        user: user,
      );
      BlocProvider.of<HistoryCubit>(context)
          .addNewEquipments(equipmentEntity: HistoryEntity(
        event: "User has been deleted",
        actionDoneBy: "${user.accountType}",
        name: user.name,
        time: Timestamp.now(),
      ));
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Delete ${user.name}"),
    content: Text("Are you sure you want to delete ${user.name}?"),
    actions: [
      cancelButton,
      yesButton
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


logoutAlertMenuItemDialog(BuildContext context,EquipmentEntity equipmentEntity,UserEntity user) {
  // set up the button
  Widget cancelButton = TextButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget yesButton = TextButton(
    child: Text("Yes"),
    onPressed: () {
      BlocProvider.of<EquipmentCubit>(context).getDeleteEquipments(equipmentEntity: equipmentEntity);
      BlocProvider.of<HistoryCubit>(context)
          .addNewEquipments(equipmentEntity: HistoryEntity(
        event: "Item has been deleted",
        actionDoneBy: "${user.accountType}(${equipmentEntity.name})",
        name: equipmentEntity.name,
        time: Timestamp.now(),
      ));

      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Delete ${equipmentEntity.name}"),
    content: Text("Are you sure you want to delete ${equipmentEntity.name}?"),
    actions: [
      cancelButton,
      yesButton
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