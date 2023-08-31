






import 'package:veris/features/domain/repositories/firebase_repository.dart';

class SignOutUseCase{
  final FirebaseRepository repository;

  SignOutUseCase({required this.repository});

  Future<void> call(){
    return repository.signOut();
  }
}