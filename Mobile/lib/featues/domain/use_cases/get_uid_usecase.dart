





import 'package:veris_mobile/featues/domain/repositories/firebase_repository.dart';

class GetUidUseCase{
  final FirebaseRepository repository;

  GetUidUseCase({required this.repository});

  Future<String> call(){
    return repository.getUid();
  }
}