





import 'package:veris_mobile/featues/data/remote/models/pick_item_queue_data.dart';
import 'package:veris_mobile/featues/domain/repositories/firebase_repository.dart';

class GetRemoveForWaitingEquipmentUseCase{
  final FirebaseRepository repository;

  GetRemoveForWaitingEquipmentUseCase({required this.repository});

  Future<void> call(PickItemQueueData pickItemQueueData){
    return repository.removeForWaitingEquipment(pickItemQueueData);
  }
}