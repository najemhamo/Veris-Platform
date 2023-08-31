





import 'package:veris/features/domain/entities/history_entity.dart';
import 'package:veris/features/domain/repositories/firebase_repository.dart';

class AddNewHistoryUseCase{
  final FirebaseRepository repository;

  AddNewHistoryUseCase({required this.repository});

  Future<void> call(HistoryEntity history){
    return repository.addNewHistory(history);
  }
}