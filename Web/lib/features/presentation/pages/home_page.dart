import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veris/const.dart';
import 'package:veris/features/data/remote/models/user_model.dart';
import 'package:veris/features/domain/entities/user_entity.dart';
import 'package:veris/features/presentation/cubit/auth/auth_cubit.dart';
import 'package:veris/features/presentation/cubit/user/user_cubit.dart';
import 'package:veris/features/presentation/pages/add_new_user_page.dart';
import 'package:veris/features/presentation/pages/profile_page.dart';
import 'package:veris/features/presentation/s_pages/s_home_page.dart';
import 'package:veris/features/presentation/widgets/common/alert_message_widget.dart';
import 'package:veris/features/presentation/widgets/nav_widgets/nav_profile_menu_widget.dart';
import 'package:veris/features/presentation/widgets/nav_widgets/vertical_navigation_widget.dart';
import 'package:veris/features/presentation/widgets/theme/style.dart';

import 'all_equipment_page.dart';
import 'all_users_page.dart';
import 'equipment_details_page.dart';
import 'equipment_page.dart';
import 'equipment_report_page.dart';


class HomePage extends StatefulWidget {
  final String uid;
  const HomePage({Key? key,required this.uid}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _pageIndex=1;



  @override
  void initState() {
    BlocProvider.of<UserCubit>(context).getUsers();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<UserCubit,UserState>(
        listener: (context,userState){

          // if (userState is UserLoaded){
          //   final user=userState.users.firstWhere((user) => user.uid==widget.uid,orElse: () => UserModel());
          //   if (user.accountType==UserConst.student){
          //     BlocProvider.of<AuthCubit>(context).loggedOut();
          //   }
          // }

        },
        builder: (context,userState){
          if (userState is UserLoaded){

            final user=userState.users.firstWhere((user) => user.uid==widget.uid,orElse: () => UserModel());

            if (user.accountType==UserConst.student){
              return SHomePage(uid:widget.uid);
            }else if (user.isDisable==true){
              return AlertMessageWidget(title: UserConst.disabledMessage);
            }else{
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VerticalNavigationWidget(onPageChangeIndexCallBack: (index){
                    print(index);
                    setState(() {
                      _pageIndex=index;
                    });
                  },),
                  SizedBox(width: 10,),
                  Expanded(
                    child: Column(
                      children: [
                        NavProfileNavWidget(uid: widget.uid,),
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
              );
            }




          }

          return Center(child: CircularProgressIndicator(),);
        },
      ),
    );
  }
  Widget _pages(UserEntity user){
    switch(_pageIndex){
      case 1:{
        return Expanded(child: GetAllEquipments(user: user,));
      }
      case 2:{
        return SettingsProfileWidget(user: user,);
      }
      case 3:{
        return Expanded(child: AddNewUserPage(user: user,));
      }
      case 4:{
        return Expanded(child: AllUsersPage(
          user: user,
        ));
      }
      case 5:{
        return Expanded(child: EquipmentPage(user: user,));
      }
      case 6:{
        return Expanded(child: EquipmentsDetailsPage(user:user));
      }
      case 7:{
        return Expanded(child: EquipmentsReportPage());
      }

      default:
        return Container();
    }
  }
}