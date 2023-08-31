








import 'package:veris_mobile/featues/domain/repositories/firebase_repository.dart';

class IsSignInUseCase{
  final FirebaseRepository repository;

  IsSignInUseCase({required this.repository});

  Future<bool> call(){
    return repository.isSignIn();
  }
}