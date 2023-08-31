import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:veris/features/domain/entities/user_entity.dart';
import 'package:veris/features/domain/use_cases/get_uid_usecase.dart';
import 'package:veris/features/domain/use_cases/get_update_user_usecase.dart';
import 'package:veris/features/domain/use_cases/get_users_usecase.dart';
part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final GetUidUseCase getUidUseCase;
  final GetUsersUseCase getUsersUseCase;
  final GetUpdateUserUseCase getUpdateUser;
  UserCubit({required this.getUpdateUser,required this.getUsersUseCase,required this.getUidUseCase}) : super(UserInitial());


  Future<void> getUsers()async{
    emit(UserLoading());
   try{
     final streamResponse= getUsersUseCase.call();
     final uid=await getUidUseCase.call();
     print("myuid $uid");
     streamResponse.listen((users) {
       emit(UserLoaded(users: users,uid: uid));
     });
   }on SocketException catch(_){
     emit(UserFailure());
   }catch(_){
     emit(UserFailure());
   }
  }

  Future<void> updateUser({required UserEntity user})async{
    try{
      await getUpdateUser.call(user);
    }on SocketException catch(_){
      emit(UserFailure());
    }catch(_){
      emit(UserFailure());
    }
  }

}
