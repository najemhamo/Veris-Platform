








import 'package:veris_mobile/featues/domain/entities/user_entity.dart';
import 'package:veris_mobile/featues/domain/repositories/firebase_repository.dart';

class SignInUseCase{
  final FirebaseRepository repository;

  SignInUseCase({required this.repository});

  Future<void> call(UserEntity user){
    return repository.signIn(user);
  }
}