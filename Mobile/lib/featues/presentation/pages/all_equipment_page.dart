import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veris_mobile/const.dart';
import 'package:veris_mobile/featues/data/remote/models/pick_item_queue_data.dart';
import 'package:veris_mobile/featues/domain/entities/equipment_entity.dart';
import 'package:veris_mobile/featues/domain/entities/history_entity.dart';
import 'package:veris_mobile/featues/domain/entities/userEquipmentEntity.dart';
import 'package:veris_mobile/featues/domain/entities/user_entity.dart';
import 'package:veris_mobile/featues/presentation/cubit/equipment/equipment_cubit.dart';
import 'package:veris_mobile/featues/presentation/cubit/history/history_cubit.dart';
import 'package:veris_mobile/featues/presentation/widgets/common.dart';
import 'package:veris_mobile/featues/presentation/widgets/equipment_photo_widget.dart';
import 'package:veris_mobile/featues/presentation/widgets/submit_button_widget.dart';
import 'package:veris_mobile/featues/presentation/widgets/theme/style.dart';

class GetAllEquipments extends StatefulWidget {
  final UserEntity user;
  final String searchQuery;
  const GetAllEquipments({Key? key, required this.user,required this.searchQuery}) : super(key: key);

  @override
  _GetAllEquipmentsState createState() => _GetAllEquipmentsState();
}

class _GetAllEquipmentsState extends State<GetAllEquipments> {
  List<String> _queue = [];

  @override
  void initState() {
    print(widget.user.uid);
    BlocProvider.of<EquipmentCubit>(context).getEquipments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EquipmentCubit, EquipmentState>(
        builder: (context, equipmentState) {
      if (equipmentState is EquipmentLoaded) {


        final filteredEquipment = equipmentState.equipments.where((ep) =>
        ep.name!.startsWith(widget.searchQuery) ||
            ep.name!.startsWith(widget.searchQuery) ||
            ep.name!.toLowerCase().startsWith(widget.searchQuery.toLowerCase())
        ).toList();


        return filteredEquipment.isEmpty
            ? Center(child: Text("No Equipment added yet"))
            : GridView.builder(
                itemCount: filteredEquipment.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 0.65),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        PageConst.singleItemPage,
                        arguments: UserEquipmentEntity(
                            user: widget.user,
                            equipment: filteredEquipment[index]),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Container(
                            height: 140,
                            width: 140,
                            child: equipmentPhotoWidget(
                                imageUrl: filteredEquipment[index].equipmentPhoto),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            "${filteredEquipment[index].name}",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            "${filteredEquipment[index].description}",
                            maxLines: 3,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SubmitButtonWidget(
                                color: filteredEquipment[index].queue!
                                        .contains(widget.user.uid)
                                    ? color583BD1.withOpacity(.2)
                                    : color583BD1,
                                text: filteredEquipment[index]
                                    .queue!.length ==
                                    filteredEquipment[index].quantity!?
                                filteredEquipment[index].waitingQueueId!
                                    .contains(widget.user.uid)?
                                "Booked":"Book":"Pickup",
                                onTap: filteredEquipment[index].pickQueue!
                                        .contains(widget.user.uid)
                                    ? null
                                    : () {
                                        print(filteredEquipment[index].queue!.length);
                                        if (filteredEquipment[index]
                                                .queue!.length ==
                                            filteredEquipment[index].quantity!) {
                                          toast(
                                              "${filteredEquipment[index].name} not available yet.");


                                         if(filteredEquipment[index].waitingQueueId!
                                              .contains(widget.user.uid)){

                                           BlocProvider.of<EquipmentCubit>(
                                               context)
                                               .getRemoveForWaitingEquipments(
                                               pickItemQueueData:
                                               PickItemQueueData(
                                               uid: widget.user.uid,
                                                 equipmentId:filteredEquipment[index].equipmentId,
                                                 time: Timestamp.now()
                                               ));
                                           Future.delayed(Duration(seconds: 1),(){
                                             toast("${filteredEquipment[index].name} Remove From Waiting Queue.");
                                           });
                                           return;
                                         }else{


                                           BlocProvider.of<EquipmentCubit>(
                                               context)
                                               .getWaitingForEquipments(
                                               pickItemQueueData:
                                               PickItemQueueData(
                                                   uid: widget.user.uid,
                                                   equipmentId: filteredEquipment[index].equipmentId,
                                                   time: Timestamp.now()
                                               ));
                                           Future.delayed(Duration(seconds: 1),(){
                                             toast("${filteredEquipment[index].name} Added In Waiting Queue.");
                                           });
                                           BlocProvider.of<HistoryCubit>(context)
                                               .addNewEquipments(equipmentEntity: HistoryEntity(
                                             event: "Item has been booked",
                                             actionDoneBy: "${widget.user.accountType}(${widget.user.name})",
                                             name: filteredEquipment[index].name,
                                             time: Timestamp.now(),
                                           ));
                                         }
                                          return;
                                        }



                                        if (filteredEquipment[index].queue!
                                            .contains(widget.user.uid)){
                                          return;
                                        }else{
                                          BlocProvider.of<EquipmentCubit>(context)
                                              .getPickUpEquipments(
                                            pickItemQueueData: PickItemQueueData(
                                                uid: widget.user.uid,
                                                equipmentId: filteredEquipment[index].equipmentId,
                                                time: Timestamp.now()
                                            ),
                                          );
                                          BlocProvider.of<HistoryCubit>(context)
                                              .addNewEquipments(equipmentEntity: HistoryEntity(
                                            event: "Item has been pickedup",
                                            actionDoneBy: "${widget.user.accountType}(${widget.user.name})",
                                            name: filteredEquipment[index].name,
                                            time: Timestamp.now(),
                                          ));
                                        }

                                      },
                              ),
                              SubmitButtonWidget(
                                color: !filteredEquipment[index].queue!
                                        .contains(widget.user.uid)
                                    ? color583BD1.withOpacity(.2)
                                    : color583BD1,
                                text: "Return",
                                onTap: !filteredEquipment[index].queue!
                                        .contains(widget.user.uid)
                                    ? null
                                    : () {
                                        BlocProvider.of<EquipmentCubit>(context)
                                            .getDropEquipments(
                                          pickItemQueueData: PickItemQueueData(
                                            uid: widget.user.uid,
                                            equipmentId:filteredEquipment[index].equipmentId,
                                            time: Timestamp.now()
                                          ),
                                        );
                                        BlocProvider.of<HistoryCubit>(context)
                                            .addNewEquipments(equipmentEntity: HistoryEntity(
                                          event: "Item has been returned",
                                          actionDoneBy: "${widget.user.accountType}(${widget.user.name})",
                                          name: filteredEquipment[index].name,
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
}
