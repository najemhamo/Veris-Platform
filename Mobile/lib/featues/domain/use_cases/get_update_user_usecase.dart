








import 'package:veris_mobile/featues/domain/entities/user_entity.dart';
import 'package:veris_mobile/featues/domain/repositories/firebase_repository.dart';

class GetUpdateUserUseCase{
  final FirebaseRepository repository;

  GetUpdateUserUseCase({required this.repository});

  Future<void> call(UserEntity user){
    return repository.getUpdateUser(user);
  }
}