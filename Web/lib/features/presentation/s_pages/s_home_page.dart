import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veris/const.dart';
import 'package:veris/features/data/remote/models/user_model.dart';
import 'package:veris/features/domain/entities/user_entity.dart';
import 'package:veris/features/presentation/cubit/auth/auth_cubit.dart';
import 'package:veris/features/presentation/cubit/user/user_cubit.dart';
import 'package:veris/features/presentation/pages/add_new_user_page.dart';
import 'package:veris/features/presentation/pages/all_equipment_page.dart';
import 'package:veris/features/presentation/pages/all_users_page.dart';
import 'package:veris/features/presentation/pages/profile_page.dart';
import 'package:veris/features/presentation/s_pages/s_all_equipment_page.dart';
import 'package:veris/features/presentation/s_pages/s_my_equipment_page.dart';
import 'package:veris/features/presentation/s_pages/s_nav_widgets/s_nav_profile_menu_widget.dart';
import 'package:veris/features/presentation/s_pages/s_nav_widgets/s_vertical_navigation_widget.dart';
import 'package:veris/features/presentation/s_pages/s_profile_page.dart';
import 'package:veris/features/presentation/widgets/common/alert_message_widget.dart';
import 'package:veris/features/presentation/widgets/nav_widgets/nav_profile_menu_widget.dart';



class SHomePage extends StatefulWidget {
  final String uid;
  const SHomePage({Key? key,required this.uid}) : super(key: key);

  @override
  _SHomePageState createState() => _SHomePageState();
}

class _SHomePageState extends State<SHomePage> {

  int _pageIndex=1;



  @override
  void initState() {
    BlocProvider.of<UserCubit>(context).getUsers();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SVerticalNavigationWidget(onPageChangeIndexCallBack: (index){
          print(index);
          setState(() {
            _pageIndex=index;
          });
        },),
        SizedBox(width: 10,),
        Expanded(
          child: Column(
            children: [
              SNavProfileNavWidget(uid: widget.uid,),
              BlocBuilder<UserCubit,UserState>(builder: (context,userState){
                if (userState is UserLoaded){
                  final user=userState.users.firstWhere((element) => element.uid==widget.uid,orElse: () => UserModel());
                  return _pages(user);
                }
                return CircularProgressIndicator();
              }),
            ],
          ),
        ),
      ],
    ),
    );
  }
  Widget _pages(UserEntity user){
    switch(_pageIndex){
      case 1:{
        return Expanded(child: SGetAllEquipments(user: user,));
      }
      case 2:{
        return SProfileWidget();
      }
      case 3:{
        return Expanded(child: SGetMyEquipmentsPage(uid: widget.uid,));
      }

      default:
        return Container();
    }
  }
}