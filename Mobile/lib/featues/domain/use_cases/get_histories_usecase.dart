





import 'package:veris_mobile/featues/domain/entities/history_entity.dart';
import 'package:veris_mobile/featues/domain/repositories/firebase_repository.dart';

class GetHistoriesUseCase{
  final FirebaseRepository repository;

  GetHistoriesUseCase({required this.repository});

  Stream<List<HistoryEntity>> call(){
    return repository.getHistories();
  }
}