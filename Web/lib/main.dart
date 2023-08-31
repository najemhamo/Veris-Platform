import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veris/features/presentation/cubit/equipment/equipment_cubit.dart';
import 'package:veris/features/presentation/cubit/history/history_cubit.dart';
import 'package:veris/features/presentation/pages/home_page.dart';
import 'package:veris/features/presentation/pages/login_page.dart';
import 'features/presentation/cubit/auth/auth_cubit.dart';
import 'features/presentation/cubit/credential/credential_cubit.dart';
import 'features/presentation/cubit/user/user_cubit.dart';
import 'injection_container.dart' as di;
import 'package:firebase_core/firebase_core.dart';
import 'on_generate_route.dart';

///superadmin@gmail.com
///123456
//TERMINAL: [flutter run -d chrome --web-renderer html --no-sound-null-safety]



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
          create: (_) => di.sl<UserCubit>(),
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
                  return HomePage(uid: authState.uid,);
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
