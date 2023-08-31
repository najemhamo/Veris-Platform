



import 'package:veris/features/domain/entities/user_entity.dart';
import 'package:veris/features/domain/repositories/firebase_repository.dart';

class GetUsersUseCase{
  final FirebaseRepository repository;

  GetUsersUseCase({required this.repository});

  Stream<List<UserEntity>> call(){
    return repository.getUsers();
  }
}