





import 'package:veris_mobile/featues/domain/entities/equipment_entity.dart';
import 'package:veris_mobile/featues/domain/repositories/firebase_repository.dart';

class GetEquipmentsUseCase{
  final FirebaseRepository repository;

  GetEquipmentsUseCase({required this.repository});

  Stream<List<EquipmentEntity>> call(){
    return repository.getEquipments();
  }
}