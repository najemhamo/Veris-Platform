



import 'package:veris/features/data/remote/models/pick_item_queue_data.dart';
import 'package:veris/features/domain/entities/equipment_entity.dart';
import 'package:veris/features/domain/entities/history_entity.dart';
import 'package:veris/features/domain/entities/user_entity.dart';

abstract class FirebaseRepository{
  Future<bool> isSignIn();
  Future<void> signIn(UserEntity user);
  Future<void> signUp(UserEntity user);
  Future<void> signOut();
  Future<String> getUid();
  Future<void> getUpdateUser(UserEntity user);
  Future<void> getInitializedCurrentUser(UserEntity user);
  Future<void> getAddNewEquipment(EquipmentEntity equipmentEntity);
  Future<void> getUpdateEquipment(EquipmentEntity equipmentEntity);
  Future<void> getDeleteEquipment(EquipmentEntity equipmentEntity);
  Future<void> forgotPassword(String email);
  Stream<List<UserEntity>> getUsers();
  Stream<List<EquipmentEntity>> getEquipments();


  //history
  Future<void> addNewHistory(HistoryEntity user);
  Stream<List<HistoryEntity>> getHistories();



  Future<void> pickupItem(PickItemQueueData pickItemQueueData);
  Future<void> dropItem(PickItemQueueData pickItemQueueData);
  Future<void> waitingForEquipment(PickItemQueueData pickItemQueueData);
  Future<void> removeForWaitingEquipment(PickItemQueueData pickItemQueueData);
  Future<void> assignEquipment(PickItemQueueData pickItemQueueData);
}