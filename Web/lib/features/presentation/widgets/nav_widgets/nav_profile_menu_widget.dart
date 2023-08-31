import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:veris/features/data/remote/models/user_model.dart';
import 'package:veris/features/domain/entities/user_entity.dart';
import 'package:veris/features/presentation/cubit/auth/auth_cubit.dart';
import 'package:veris/features/presentation/cubit/user/user_cubit.dart';
import 'package:veris/features/presentation/widgets/alert_dialog_widgets/add_new_equipment_alert_dialog_widget.dart';
import 'package:veris/features/presentation/widgets/nav_widgets/profile_image_widget.dart';
import 'package:veris/features/presentation/widgets/theme/style.dart';

class NavProfileNavWidget extends StatefulWidget {
  final String uid;
  const NavProfileNavWidget({Key? key,required this.uid}) : super(key: key);

  @override
  _NavProfileNavWidgetState createState() => _NavProfileNavWidgetState();
}

class _NavProfileNavWidgetState extends State<NavProfileNavWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.1),
                offset: Offset(0.0,0.50),
                spreadRadius: 2,
                blurRadius: 2
            )
          ]
      ),
      child: BlocBuilder<UserCubit,UserState>(
        builder: (context,userState){

          if (userState is UserLoaded){

            final user=userState.users.firstWhere((user) => user.uid==userState.uid,orElse: () => UserModel());


            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buttonsRowWidget(),
                _profileRowWidget(user),
              ],
            );
          }

          return Center(child: CircularProgressIndicator(),);
        },
      ),
    );
  }

  _buttonsRowWidget() {
    return Row(
      children: [
        Text("Teams"),
        SizedBox(
          width: 15,
        ),
        AddNewEquipmentAlertDialogWidget(),
      ],
    );
  }

  _profileRowWidget(UserEntity user) {
    return Row(
      children: [
        Text(user.name==null|| user.name==""?"username":"${user.name}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700),),
        SizedBox(width: 5,),
        _profileWidget(profile: user.profileUrl),
        SizedBox(
          width: 15,
        ),
        InkWell(onTap: (){
          BlocProvider.of<AuthCubit>(context).loggedOut();
        },child: Icon(MaterialCommunityIcons.location_exit)),
      ],
    );
  }

  Widget _profileWidget({String? profile = "", bool isColor = false}) {
    return Container(
      height: 34,
      width: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        color: isColor == false ? Colors.grey.withOpacity(.4) : color583BD1,
      ),
      child:profileImageWidget(
        //FIXME:pass profile image
        imageUrl: profile,
      ),
    );
  }
}
