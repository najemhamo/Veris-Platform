import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veris_mobile/featues/presentation/screens/home_screen.dart';
import 'featues/presentation/cubit/auth/auth_cubit.dart';
import 'featues/presentation/cubit/credential/credential_cubit.dart';
import 'featues/presentation/cubit/equipment/equipment_cubit.dart';
import 'featues/presentation/cubit/history/history_cubit.dart';
import 'featues/presentation/cubit/user/user_cubit.dart';
import 'featues/presentation/pages/home_page.dart';
import 'featues/presentation/pages/login_page.dart';
import 'injection_container.dart' as di;
import 'package:firebase_core/firebase_core.dart';
import 'on_generate_route.dart';

//User: student@bth.se
//User1: najem@student.bth.se
//Password: 123456

//TERMINAL: [flutter run --no-sound-null-safety]

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => di.sl<AuthCubit>()..appStarted(),
        ),
        BlocProvider<UserCubit>(
          create: (_) => di.sl<UserCubit>()..getUsers(),
        ),
        BlocProvider<CredentialCubit>(
          create: (_) => di.sl<CredentialCubit>(),
        ),
        BlocProvider<EquipmentCubit>(
          create: (_) => di.sl<EquipmentCubit>(),
        ),
        BlocProvider<HistoryCubit>(
          create: (_) => di.sl<HistoryCubit>(),
        ),
      ],
      child: MaterialApp(
        title: 'Veris',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        onGenerateRoute: OnGenerateRoute.route,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        routes: {
          "/": (context) {
            return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                if (authState is Authenticated) {
                  return HomeScreen(
                    uid: authState.uid,
                  );
                } else
                  return LoginPage();
              },
            );
          }
        },
      ),
    );
  }
}
