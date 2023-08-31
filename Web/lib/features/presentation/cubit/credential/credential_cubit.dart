import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:veris/features/domain/entities/user_entity.dart';
import 'package:veris/features/domain/use_cases/forgot_password_usecase.dart';
import 'package:veris/features/domain/use_cases/get_initilized_new_user_usecase.dart';
import 'package:veris/features/domain/use_cases/sign_in_usecase.dart';
import 'package:veris/features/domain/use_cases/sign_up_usecase.dart';
part 'credential_state.dart';

class CredentialCubit extends Cubit<CredentialState> {
  final SignUpUseCase signUpUseCase;
  final SignInUseCase signInUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final GetInitializedCurrentUserUseCase getInitializedCurrentUserUseCase;

  CredentialCubit(
      {required this.signUpUseCase, required this.signInUseCase, required this.forgotPasswordUseCase, required this.getInitializedCurrentUserUseCase})
      : super(CredentialInitial());


  Future<void> forgotPassword({required String email}) async {
    try {
      await forgotPasswordUseCase.call(email);
    } on SocketException catch (_) {
      emit(CredentialFailure());
    } catch (_) {
      emit(CredentialFailure());
    }
  }

  Future<void> signInSubmit({required UserEntity user}) async {
    emit(CredentialLoading());
    try {
      await signInUseCase.call(user);
      emit(CredentialSuccess());
    } on SocketException catch (_) {
      emit(CredentialFailure());
    } catch (_) {
      emit(CredentialFailure());
    }
  }

  Future<void> signUpSubmit({required UserEntity user}) async {
    emit(CredentialLoading());
    try {
      await signUpUseCase.call(user);
      await getInitializedCurrentUserUseCase.call(user);
      emit(CredentialSuccess());
    } on SocketException catch (_) {
      emit(CredentialFailure());
    } catch (_) {
      emit(CredentialFailure());
    }
  }

  Future<void> submitNewUser({required UserEntity user}) async {
    try {
      await signUpUseCase.call(user);
      await getInitializedCurrentUserUseCase.call(user);
    } on SocketException catch (_) {
      emit(CredentialFailure());
    } catch (_) {
      emit(CredentialFailure());
    }
  }
}