








import 'package:veris/features/data/remote/models/pick_item_queue_data.dart';
import 'package:veris/features/domain/repositories/firebase_repository.dart';

class GetDropEquipmentUseCase{
  final FirebaseRepository repository;

  GetDropEquipmentUseCase({required this.repository});

  Future<void> call(PickItemQueueData pickItemQueueData){
    return repository.dropItem(pickItemQueueData);
  }

}