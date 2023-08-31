



import 'package:veris/features/domain/entities/equipment_entity.dart';
import 'package:veris/features/domain/entities/history_entity.dart';
import 'package:veris/features/domain/entities/user_entity.dart';
import 'package:veris/features/domain/repositories/firebase_repository.dart';

class GetHistoriesUseCase{
  final FirebaseRepository repository;

  GetHistoriesUseCase({required this.repository});

  Stream<List<HistoryEntity>> call(){
    return repository.getHistories();
  }
}