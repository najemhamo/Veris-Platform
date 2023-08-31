import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:veris_mobile/featues/domain/use_cases/get_uid_usecase.dart';
import 'package:veris_mobile/featues/domain/use_cases/is_sign_in_usecse.dart';
import 'package:veris_mobile/featues/domain/use_cases/sign_out_usecase.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final IsSignInUseCase isSignInUseCase;
  final SignOutUseCase signOutUseCase;
  final GetUidUseCase getUidUseCase;

  AuthCubit({required this.isSignInUseCase,required this.signOutUseCase,required this.getUidUseCase}) : super(AuthInitial());

  Future<void> appStarted()async{
    try{
      bool isSignIn=await isSignInUseCase.call();
      print(isSignIn);
      if (isSignIn==true){
        final uid=await getUidUseCase.call();

        emit(Authenticated(uid:uid));
      }else
        emit(UnAuthenticated());

    }catch(_){
      emit(UnAuthenticated());
    }
  }
  Future<void> loggedIn()async{
    try{
       final uid=await getUidUseCase.call();
       print("user Id $uid");
      emit(Authenticated(uid: uid));
    }catch(_){
      print("user Id null");
      emit(UnAuthenticated());
    }
  }
  Future<void> loggedOut()async{
    try{
      await signOutUseCase.call();
      emit(UnAuthenticated());
    }catch(_){
      emit(UnAuthenticated());
    }
  }

}
