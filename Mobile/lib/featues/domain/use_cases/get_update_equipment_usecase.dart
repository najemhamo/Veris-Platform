






import 'package:veris_mobile/featues/domain/entities/equipment_entity.dart';
import 'package:veris_mobile/featues/domain/repositories/firebase_repository.dart';

class GetUpdateEquipmentUseCase{
  final FirebaseRepository repository;

  GetUpdateEquipmentUseCase({required this.repository});

  Future<void> call(EquipmentEntity equipmentEntity){
    return repository.getUpdateEquipment(equipmentEntity);
  }

}