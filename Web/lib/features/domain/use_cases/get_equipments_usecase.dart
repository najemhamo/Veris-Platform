



import 'package:veris/features/domain/entities/equipment_entity.dart';
import 'package:veris/features/domain/entities/user_entity.dart';
import 'package:veris/features/domain/repositories/firebase_repository.dart';

class GetEquipmentsUseCase{
  final FirebaseRepository repository;

  GetEquipmentsUseCase({required this.repository});

  Stream<List<EquipmentEntity>> call(){
    return repository.getEquipments();
  }
}