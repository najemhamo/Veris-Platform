






import 'package:veris_mobile/featues/data/remote/models/pick_item_queue_data.dart';
import 'package:veris_mobile/featues/domain/entities/equipment_entity.dart';
import 'package:veris_mobile/featues/domain/repositories/firebase_repository.dart';

class GetPickUpEquipmentUseCase{
  final FirebaseRepository repository;

  GetPickUpEquipmentUseCase({required this.repository});

  Future<void> call(PickItemQueueData pickItemQueueData){
    //return repository.getPickUpEquipment(equipmentEntity);
    return repository.pickupItem(pickItemQueueData);
  }

}