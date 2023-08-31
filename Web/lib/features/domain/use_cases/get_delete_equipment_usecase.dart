





import 'package:veris/features/domain/entities/equipment_entity.dart';
import 'package:veris/features/domain/entities/user_entity.dart';
import 'package:veris/features/domain/repositories/firebase_repository.dart';

class GetDeleteEquipmentUseCase{
  final FirebaseRepository repository;

  GetDeleteEquipmentUseCase({required this.repository});

  Future<void> call(EquipmentEntity equipmentEntity){
    return repository.getDeleteEquipment(equipmentEntity);
  }
}