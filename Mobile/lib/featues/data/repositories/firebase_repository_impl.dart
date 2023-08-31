



import 'package:veris_mobile/featues/data/remote/data_sources/firebase_remote_data_source.dart';
import 'package:veris_mobile/featues/data/remote/models/pick_item_queue_data.dart';
import 'package:veris_mobile/featues/domain/entities/equipment_entity.dart';
import 'package:veris_mobile/featues/domain/entities/history_entity.dart';
import 'package:veris_mobile/featues/domain/entities/user_entity.dart';
import 'package:veris_mobile/featues/domain/repositories/firebase_repository.dart';

class FirebaseRepositoryImpl implements FirebaseRepository{
  final FirebaseRemoteDataSource remoteDataSource;

  FirebaseRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> forgotPassword(String email) async =>
      remoteDataSource.forgotPassword(email);

  @override
  Future<String> getUid() async =>
      remoteDataSource.getUid();
  

  @override
  Future<void> getUpdateUser(UserEntity user) async =>
      remoteDataSource.getUpdateUser(user);

  @override
  Stream<List<UserEntity>> getUsers() =>
      remoteDataSource.getUsers();

  @override
  Future<bool> isSignIn() async =>
      remoteDataSource.isSignIn();

  @override
  Future<void> signIn(UserEntity user)  async =>
      remoteDataSource.signIn(user);

  @override
  Future<void> signOut() async =>
      remoteDataSource.signOut();

  @override
  Future<void> signUp(UserEntity user)  async =>
      remoteDataSource.signUp(user);

  @override
  Stream<List<EquipmentEntity>> getEquipments() =>
      remoteDataSource.getEquipments();

  @override
  Future<void> getUpdateEquipment(EquipmentEntity equipmentEntity) async =>
      remoteDataSource.getUpdateEquipment(equipmentEntity);

  @override
  Future<void> getPickUpEquipment(EquipmentEntity equipmentEntity) async =>
      remoteDataSource.getPickUpEquipment(equipmentEntity);

  @override
  Future<void> getDropEquipment(EquipmentEntity equipmentEntity) async =>
      remoteDataSource.getDropEquipment(equipmentEntity);

  @override
  Future<void> pickupItem(PickItemQueueData pickItemQueueData) async =>
      remoteDataSource.pickupItem(pickItemQueueData);

  @override
  Future<void> dropItem(PickItemQueueData pickItemQueueData) async =>
      remoteDataSource.dropItem(pickItemQueueData);

  @override
  Future<void> assignEquipment(PickItemQueueData pickItemQueueData) async =>
      remoteDataSource.assignEquipment(pickItemQueueData);

  @override
  Future<void> removeForWaitingEquipment(PickItemQueueData pickItemQueueData) async =>
      remoteDataSource.removeForWaitingEquipment(pickItemQueueData);

  @override
  Future<void> waitingForEquipment(PickItemQueueData pickItemQueueData) async =>
      remoteDataSource.waitingForEquipment(pickItemQueueData);


  @override
  Future<void> addNewHistory(HistoryEntity user) async =>
      remoteDataSource.addNewHistory(user);

  @override
  Stream<List<HistoryEntity>> getHistories() =>
      remoteDataSource.getHistories();

}