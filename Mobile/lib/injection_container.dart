import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:veris_mobile/featues/domain/use_cases/get_drop_equipment_usecase.dart';
import 'package:veris_mobile/featues/domain/use_cases/get_drop_equipment_usecase.dart';
import 'package:veris_mobile/featues/domain/use_cases/get_pickup_equipment_usecase.dart';
import 'package:veris_mobile/featues/domain/use_cases/get_pickup_equipment_usecase.dart';
import 'package:veris_mobile/featues/domain/use_cases/get_remove_for_waiting_equipment_usecase.dart';
import 'package:veris_mobile/featues/domain/use_cases/get_remove_for_waiting_equipment_usecase.dart';
import 'package:veris_mobile/featues/domain/use_cases/get_waiting_for_equipment_usecase.dart';
import 'package:veris_mobile/featues/domain/use_cases/get_waiting_for_equipment_usecase.dart';
import 'featues/data/remote/data_sources/firebase_remote_data_source.dart';
import 'featues/data/remote/data_sources/firebase_remote_data_source_impl.dart';
import 'featues/data/repositories/firebase_repository_impl.dart';
import 'featues/domain/repositories/firebase_repository.dart';
import 'featues/domain/use_cases/add_new_history_usecase.dart';
import 'featues/domain/use_cases/forgot_password_usecase.dart';
import 'featues/domain/use_cases/get_equipments_usecase.dart';
import 'featues/domain/use_cases/get_histories_usecase.dart';
import 'featues/domain/use_cases/get_uid_usecase.dart';
import 'featues/domain/use_cases/get_update_equipment_usecase.dart';
import 'featues/domain/use_cases/get_update_user_usecase.dart';
import 'featues/domain/use_cases/get_users_usecase.dart';
import 'featues/domain/use_cases/is_sign_in_usecse.dart';
import 'featues/domain/use_cases/sign_in_usecase.dart';
import 'featues/domain/use_cases/sign_out_usecase.dart';
import 'featues/domain/use_cases/sign_up_usecase.dart';
import 'featues/presentation/cubit/auth/auth_cubit.dart';
import 'featues/presentation/cubit/credential/credential_cubit.dart';
import 'featues/presentation/cubit/equipment/equipment_cubit.dart';
import 'featues/presentation/cubit/history/history_cubit.dart';
import 'featues/presentation/cubit/user/user_cubit.dart';


final sl = GetIt.instance;

Future<void> init() async {
  //Future bloc
  sl.registerFactory<AuthCubit>(() => AuthCubit(
    isSignInUseCase: sl.call(),
    signOutUseCase: sl.call(),
    getUidUseCase: sl.call(),
  ));
  sl.registerFactory<UserCubit>(() => UserCubit(
    getUidUseCase: sl.call(),
    getUpdateUser: sl.call(),
    getUsersUseCase: sl.call(),
  ));
  sl.registerFactory<CredentialCubit>(() => CredentialCubit(
    forgotPasswordUseCase: sl.call(),
    signInUseCase: sl.call(),
    signUpUseCase: sl.call(),
  ));


  sl.registerFactory<EquipmentCubit>(() => EquipmentCubit(
    getEquipmentsUseCase: sl.call(),
    getUpdateEquipmentUseCase: sl.call(),
    getPickUpEquipmentUseCase: sl.call(),
    getDropEquipmentUseCase: sl.call(),
    getRemoveForWaitingEquipmentUseCase: sl.call(),
    getWaitingForEquipmentUseCase: sl.call(),
  ));

  sl.registerFactory<HistoryCubit>(() => HistoryCubit(
    addNewHistoryUseCase: sl.call(),
    getHistoriesUseCase: sl.call(),
  ));


  //UseCases

  sl.registerLazySingleton<AddNewHistoryUseCase>(
          () => AddNewHistoryUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetHistoriesUseCase>(
          () => GetHistoriesUseCase(repository: sl.call()));

  sl.registerLazySingleton<GetRemoveForWaitingEquipmentUseCase>(
          () => GetRemoveForWaitingEquipmentUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetWaitingForEquipmentUseCase>(
          () => GetWaitingForEquipmentUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetDropEquipmentUseCase>(
          () => GetDropEquipmentUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetPickUpEquipmentUseCase>(
          () => GetPickUpEquipmentUseCase(repository: sl.call()));
  sl.registerLazySingleton<ForgotPasswordUseCase>(
          () => ForgotPasswordUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetUidUseCase>(
          () => GetUidUseCase(repository: sl.call()));
  sl.registerLazySingleton<IsSignInUseCase>(
          () => IsSignInUseCase(repository: sl.call()));
  sl.registerLazySingleton<SignInUseCase>(
          () => SignInUseCase(repository: sl.call()));
  sl.registerLazySingleton<SignUpUseCase>(
          () => SignUpUseCase(repository: sl.call()));
  sl.registerLazySingleton<SignOutUseCase>(
          () => SignOutUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetUsersUseCase>(
          () => GetUsersUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetUpdateUserUseCase>(
          () => GetUpdateUserUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetEquipmentsUseCase>(
          () => GetEquipmentsUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetUpdateEquipmentUseCase>(
          () => GetUpdateEquipmentUseCase(repository: sl.call()));



  //Repository
  sl.registerLazySingleton<FirebaseRepository>(
      () => FirebaseRepositoryImpl(remoteDataSource: sl.call()));

  //Remote DataSource
  sl.registerLazySingleton<FirebaseRemoteDataSource>(() =>
      FirebaseRemoteDataSourceImpl(auth: sl.call(), fireStore: sl.call()));

  //External
  final auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;

  sl.registerLazySingleton(() => auth);
  sl.registerLazySingleton(() => fireStore);
}
