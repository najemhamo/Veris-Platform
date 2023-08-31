





import 'package:veris/features/domain/entities/equipment_entity.dart';
import 'package:veris/features/domain/entities/user_entity.dart';
import 'package:veris/features/domain/repositories/firebase_repository.dart';

class GetAddNewEquipmentUseCase{
  final FirebaseRepository repository;

  GetAddNewEquipmentUseCase({required this.repository});

  Future<void> call(EquipmentEntity equipmentEntity){
    return repository.getAddNewEquipment(equipmentEntity);
  }
}