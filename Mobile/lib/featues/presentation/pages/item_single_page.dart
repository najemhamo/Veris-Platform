import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:veris_mobile/featues/data/remote/models/equipment_model.dart';
import 'package:veris_mobile/featues/data/remote/models/pick_item_queue_data.dart';
import 'package:veris_mobile/featues/data/remote/models/user_model.dart';
import 'package:veris_mobile/featues/domain/entities/equipment_entity.dart';
import 'package:veris_mobile/featues/domain/entities/history_entity.dart';
import 'package:veris_mobile/featues/domain/entities/userEquipmentEntity.dart';
import 'package:veris_mobile/featues/presentation/cubit/equipment/equipment_cubit.dart';
import 'package:veris_mobile/featues/presentation/cubit/history/history_cubit.dart';
import 'package:veris_mobile/featues/presentation/cubit/user/user_cubit.dart';
import 'package:veris_mobile/featues/presentation/widgets/common.dart';
import 'package:veris_mobile/featues/presentation/widgets/equipment_photo_widget.dart';
import 'package:veris_mobile/featues/presentation/widgets/profile_image_widget.dart';
import 'package:veris_mobile/featues/presentation/widgets/submit_button_widget.dart';
import 'package:veris_mobile/featues/presentation/widgets/theme/style.dart';

class SingleItemPage extends StatelessWidget {
  final UserEquipmentEntity userEquipment;

  const SingleItemPage({Key? key, required this.userEquipment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${userEquipment.equipment.name}"),
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<EquipmentCubit, EquipmentState>(
          builder: (context, equipmentState) {
            if (equipmentState is EquipmentLoaded) {
              final singleEquipment = equipmentState.equipments.firstWhere(
                  (element) =>
                      element.equipmentId == userEquipment.equipment.equipmentId,
                  orElse: () => EquipmentModel());

              return Container(
                margin: EdgeInsets.all(8),
                child: Column(
                  children: [
                    Container(
                      height: 140,
                      width: 140,
                      child: equipmentPhotoWidget(
                          imageUrl: singleEquipment.equipmentPhoto),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${singleEquipment.name}",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${singleEquipment.description}",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    singleEquipment.queue!.isEmpty?Container(height: 0,width: 0,):Align(alignment: Alignment.topLeft,child: Text("Equipment Hold",textAlign: TextAlign.start,style: TextStyle(fontWeight: FontWeight.bold,),)),
                    singleEquipment.queue!.isEmpty?Container(height: 0,width: 0,):SizedBox(
                      height: 10,
                    ),
                    BlocBuilder<UserCubit,UserState>(builder: (context,userState){
                      if (userState is UserLoaded){
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: singleEquipment.queue!.length,
                            itemBuilder:(context,index){
                              final user= userState.users.firstWhere((element) => element.uid==singleEquipment.queue![index],orElse: () => UserModel());
                              return Row(
                                children: [
                                  Container(
                                    height: 54,
                                    width: 54,
                                    child: profileImageWidget(
                                        imageUrl:user.profileUrl
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              child: Text("${user.name}"),
                                            ),
                                            Container(
                                              child: Text("${DateFormat(
                                                  "dd/MMM/yyy - hh:mm a")
                                                  .format((singleEquipment
                                                  .pickQueue![index]['time'] as Timestamp)
                                                  .toDate())}"),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 4,),
                                        Container(
                                          child: Text("${user.email}"),
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

                    singleEquipment.waitingQueue!.isEmpty?Container(height: 0,width: 0,):Align(alignment: Alignment.topLeft,child: Text("Waiting Queue",textAlign: TextAlign.start,style: TextStyle(fontWeight: FontWeight.bold,),)),
                    singleEquipment.waitingQueue!.isEmpty?Container(height: 0,width: 0,):SizedBox(
                      height: 10,
                    ),
                    BlocBuilder<UserCubit,UserState>(builder: (context,userState){
                      if (userState is UserLoaded){
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: singleEquipment.waitingQueue!.length,
                            itemBuilder:(context,index){
                              final user= userState.users.firstWhere((element) => element.uid==singleEquipment.waitingQueueId![index],orElse: () => UserModel());
                              return Row(
                                children: [
                                  Container(
                                    height: 54,
                                    width: 54,
                                    child: profileImageWidget(
                                        imageUrl:user.profileUrl
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              child: Text("${user.name}"),
                                            ),
                                            Container(
                                              child: Text("${DateFormat(
                                                  "dd/MMM/yyy - hh:mm a")
                                                  .format((singleEquipment
                                                  .waitingQueue![index]['time'] as Timestamp)
                                                  .toDate())}"),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 4,),
                                        Container(
                                          child: Text("${user.email}"),
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
                          Text("${singleEquipment.quantity}")
                        ],
                      ),
                        Row(
                          children: [
                            Text(
                              "Total Available:",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            Text("${(singleEquipment.quantity!.toInt() - singleEquipment.queue!.length.toInt())}")
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SubmitButtonWidget(
                          color: singleEquipment.queue!
                              .contains(userEquipment.user.uid)
                              ? color583BD1.withOpacity(.2)
                              : color583BD1,
                          text: singleEquipment
                              .queue!.length ==
                              singleEquipment.quantity!?
                          singleEquipment.waitingQueueId!
                              .contains(userEquipment.user.uid)?
                          "Booked":"Book":"Pickup",
                          onTap: singleEquipment.pickQueue!
                              .contains(userEquipment.user.uid)
                              ? null
                              : () {
                            if (singleEquipment
                                .queue!.length ==
                                singleEquipment.quantity!) {

                              if(singleEquipment.waitingQueueId!
                                  .contains(userEquipment.user.uid)){

                                BlocProvider.of<EquipmentCubit>(
                                    context)
                                    .getRemoveForWaitingEquipments(
                                    pickItemQueueData:
                                    PickItemQueueData(
                                        uid: userEquipment.user.uid,
                                        equipmentId: userEquipment
                                            .equipment.equipmentId,
                                        time: Timestamp.now()
                                    ));
                                Future.delayed(Duration(seconds: 1),(){
                                  toast("${singleEquipment.name} Remove From Waiting Queue.");
                                });
                                return;
                              }else{


                                BlocProvider.of<EquipmentCubit>(
                                    context)
                                    .getWaitingForEquipments(
                                    pickItemQueueData:
                                    PickItemQueueData(
                                        uid: userEquipment.user.uid,
                                        equipmentId: singleEquipment.equipmentId,
                                        time: Timestamp.now()
                                    ));
                                toast("${singleEquipment.name} Booked. ${singleEquipment.name} Added In Waiting Queue.");
                                BlocProvider.of<HistoryCubit>(context)
                                    .addNewEquipments(equipmentEntity: HistoryEntity(
                                  event: "Item has been booked",
                                  actionDoneBy: "${userEquipment.user.accountType}(${userEquipment.user.name})",
                                  name: singleEquipment.name,
                                  time: Timestamp.now(),
                                ));

                              }
                              return;
                            }



                            if (singleEquipment.queue!
                                .contains(userEquipment.user.uid)){
                              return;
                            }else{
                              BlocProvider.of<EquipmentCubit>(context)
                                  .getPickUpEquipments(
                                pickItemQueueData: PickItemQueueData(
                                    uid: userEquipment.user.uid,
                                    equipmentId: singleEquipment.equipmentId,
                                    time: Timestamp.now()
                                ),
                              );
                              BlocProvider.of<HistoryCubit>(context)
                                  .addNewEquipments(equipmentEntity: HistoryEntity(
                                event: "Item has been pickedup",
                                actionDoneBy: "${userEquipment.user.accountType}(${userEquipment.user.name})",
                                name: singleEquipment.name,
                                time: Timestamp.now(),
                              ));
                            }

                          },
                        ),
                        SubmitButtonWidget(
                          color: !singleEquipment.queue!
                              .contains(userEquipment.user.uid)
                              ? color583BD1.withOpacity(.2)
                              : color583BD1,
                          text: "Return",
                          onTap: !singleEquipment.queue!
                              .contains(userEquipment.user.uid)
                              ? null
                              : () {
                            BlocProvider.of<EquipmentCubit>(context)
                                .getDropEquipments(
                              pickItemQueueData: PickItemQueueData(
                                  uid: userEquipment.user.uid,
                                  equipmentId: userEquipment
                                      .equipment.equipmentId,
                                  time: Timestamp.now()
                              ),
                            );
                            BlocProvider.of<HistoryCubit>(context)
                                .addNewEquipments(equipmentEntity: HistoryEntity(
                              event: "Item has been returned",
                              actionDoneBy: "${userEquipment.user.accountType}(${userEquipment.user.name})",
                              name: singleEquipment.name,
                              time: Timestamp.now(),
                            ));
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
