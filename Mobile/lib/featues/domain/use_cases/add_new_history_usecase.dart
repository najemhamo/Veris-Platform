






import 'package:veris_mobile/featues/domain/entities/history_entity.dart';
import 'package:veris_mobile/featues/domain/repositories/firebase_repository.dart';

class AddNewHistoryUseCase{
  final FirebaseRepository repository;

  AddNewHistoryUseCase({required this.repository});

  Future<void> call(HistoryEntity history){
    return repository.addNewHistory(history);
  }
}