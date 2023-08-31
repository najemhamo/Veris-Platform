import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veris_mobile/const.dart';
import 'package:veris_mobile/featues/domain/entities/equipment_entity.dart';
import 'package:veris_mobile/featues/domain/entities/userEquipmentEntity.dart';
import 'package:veris_mobile/featues/domain/entities/user_entity.dart';
import 'package:veris_mobile/featues/presentation/cubit/equipment/equipment_cubit.dart';
import 'package:veris_mobile/featues/presentation/widgets/common.dart';
import 'package:veris_mobile/featues/presentation/widgets/equipment_photo_widget.dart';
import 'package:veris_mobile/featues/presentation/widgets/submit_button_widget.dart';

class MyEquipments extends StatefulWidget {
  final UserEntity user;
  final String searchQuery;
  const MyEquipments({Key? key, required this.user,required this.searchQuery}) : super(key: key);

  @override
  _MyEquipmentsState createState() => _MyEquipmentsState();
}

class _MyEquipmentsState extends State<MyEquipments> {
  List<String> _queue = [];

  @override
  void initState() {
    print(widget.user.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EquipmentCubit, EquipmentState>(
        builder: (context, equipmentState) {
      if (equipmentState is EquipmentLoaded) {




        final myEquipments=equipmentState.equipments.where((element) => element.queue!.contains(widget.user.uid)).toList();


        final myFilteredEquipment = myEquipments.where((ep) =>
        ep.name!.startsWith(widget.searchQuery) ||
            ep.name!.startsWith(widget.searchQuery) ||
            ep.name!.toLowerCase().startsWith(widget.searchQuery.toLowerCase())
        ).toList();

        return myEquipments.isEmpty
            ? Center(child: Text("No Equipment added yet"))
            : GridView.builder(
                itemCount: myFilteredEquipment.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 0.65),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, PageConst.singleItemPage,
                          arguments:UserEquipmentEntity(user: widget.user,equipment: equipmentState.equipments[index]));
                    },
                    child: Container(
                      margin: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Container(
                            height: 140,
                            width: 140,
                            child: equipmentPhotoWidget(
                                imageUrl: myFilteredEquipment[index].equipmentPhoto),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            "${myFilteredEquipment[index].name}",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            "${myFilteredEquipment[index].description}",
                            maxLines: 3,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: 4,
                          ),
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
