import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:veris_mobile/featues/domain/entities/user_entity.dart';
import 'package:veris_mobile/featues/presentation/cubit/auth/auth_cubit.dart';
import 'package:veris_mobile/featues/presentation/pages/profile_page.dart';
import 'package:veris_mobile/featues/presentation/widgets/search_widget.dart';
import 'package:veris_mobile/featues/presentation/widgets/textfield_container_widget.dart';
import 'package:veris_mobile/featues/presentation/widgets/theme/style.dart';

import '../../../const.dart';
import 'all_equipment_page.dart';
import 'my_equipments_page.dart';

class HomePage extends StatefulWidget {
  final UserEntity user;

  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchController = TextEditingController();
  PageController _pageViewController = PageController(initialPage: 0);
  bool _isSearch = false;
  int _toolBarPageIndex = 0;

  int _navIndex = 1;

  List<String> _popupMenuList = ["Logout"];

  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  GlobalKey<CurvedNavigationBarState> _navKey =
      GlobalKey<CurvedNavigationBarState>();

  List<Widget> get pages => [
        MyEquipments(
          user: widget.user,
          searchQuery: _searchController.text,
        ),
        GetAllEquipments(
          user: widget.user,
          searchQuery: _searchController.text,
        ),
        ProfilePage(user: widget.user)
      ];


  @override
  void initState() {
    _searchController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
    _pageViewController.dispose();
  }


  Widget _emptyContainer() {
    return Container(
      height: 0,
      width: 0,
    );
  }

  String _appBarTitle(){

    if (_navIndex==0){
      return "My Equipment";
    }else if (_navIndex ==1){
      return "Home";
    }else if (_navIndex ==1){
      return "Profile";
    }else{
      return "Profile";
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      bottomNavigationBar: _curvedNav(),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor:primaryColor,
        title: Row(
              children: [
                Container(
                  height: 20,
                  child: Image.asset("assets/Logo.png"),
                ),
                Text("${_appBarTitle()}"),
              ],
            ),
        actions: [

                _isSearch==true?
                InkWell(onTap: (){
                  setState(() {
                    _isSearch=!_isSearch;
                  });
                },child: Icon(Icons.close)):

                InkWell(onTap: (){
                  setState(() {
                    _isSearch=!_isSearch;
                  });
                },child: Icon(Icons.search)),
          PopupMenuButton(
              onSelected: (String value) {
                if (value == "Logout") {
                  BlocProvider.of<AuthCubit>(context).loggedOut();
                }
              },
              itemBuilder: (_) => _popupMenuList.map((menuItem) {
                return PopupMenuItem(
                  child: Text("$menuItem"),
                  value: menuItem,
                );
              }).toList()),
          SizedBox(width: 10,),
              ],
      ),
      body: Column(
        children: [
          _navIndex==2?
          _emptyContainer():
          _isSearch==true?_search():_emptyContainer(),
          Expanded(child: pages[_navIndex]),
        ],
      ),
    );
  }

  Widget _search(){
    return Column(
      children: [
        SearchWidget(
          searchHintText: "Search...",
          searchController: _searchController,
          onClearSearch: (){
            setState(() {
              _searchController.clear();
              _isSearch=!_isSearch;
            });
          },
        ),
        SizedBox(height: 10,),
      ],
    );
  }

  Widget _curvedNav() {
    return CurvedNavigationBar(
      key: _navKey,
      backgroundColor: Colors.grey.withOpacity(.1),
      height: 50,
      animationCurve: Curves.ease,
      index: _navIndex,
      animationDuration: Duration(milliseconds: 800),
      color: Colors.grey.withOpacity(.4),
      buttonBackgroundColor: Colors.black,
      items: <Widget>[
        Icon(
          Icons.inbox,
          color: _navIndex == 0 ? Colors.white : Colors.black,
        ),
        Icon(
          Icons.home,
          color: _navIndex == 1 ? Colors.white : Colors.black,
        ),
        Icon(
          Ionicons.ios_person,
          size: 30,
          color: _navIndex == 2 ? Colors.white : Colors.black,
        ),
      ],
      onTap: (index) {
        setState(() {
          _navIndex = index;
        });
      },
    );
  }
}
