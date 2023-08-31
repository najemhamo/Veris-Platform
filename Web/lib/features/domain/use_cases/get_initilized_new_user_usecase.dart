





import 'package:veris/features/domain/entities/user_entity.dart';
import 'package:veris/features/domain/repositories/firebase_repository.dart';

class GetInitializedCurrentUserUseCase{
  final FirebaseRepository repository;

  GetInitializedCurrentUserUseCase({required this.repository});

  Future<void> call(UserEntity user){
    return repository.getInitializedCurrentUser(user);
  }
}