




import 'package:veris/features/domain/repositories/firebase_repository.dart';

class GetUidUseCase{
  final FirebaseRepository repository;

  GetUidUseCase({required this.repository});

  Future<String> call(){
    return repository.getUid();
  }
}