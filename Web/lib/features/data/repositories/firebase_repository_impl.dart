



import 'package:veris/features/data/remote/data_sources/firebase_remote_data_source.dart';
import 'package:veris/features/data/remote/models/pick_item_queue_data.dart';
import 'package:veris/features/domain/entities/equipment_entity.dart';
import 'package:veris/features/domain/entities/history_entity.dart';
import 'package:veris/features/domain/entities/user_entity.dart';
import 'package:veris/features/domain/repositories/firebase_repository.dart';

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
  Future<void> getInitializedCurrentUser(UserEntity user) async =>
      remoteDataSource.getInitializedCurrentUser(user);

  @override
  Future<void> getAddNewEquipment(EquipmentEntity equipmentEntity) async =>
      remoteDataSource.getAddNewEquipment(equipmentEntity);

  @override
  Stream<List<EquipmentEntity>> getEquipments() =>
      remoteDataSource.getEquipments();

  @override
  Future<void> getUpdateEquipment(EquipmentEntity equipmentEntity) async =>
      remoteDataSource.getUpdateEquipment(equipmentEntity);

  @override
  Future<void> getDeleteEquipment(EquipmentEntity equipmentEntity) async =>
      remoteDataSource.getDeleteEquipment(equipmentEntity);

  @override
  Future<void> addNewHistory(HistoryEntity user) async =>
      remoteDataSource.addNewHistory(user);

  @override
  Stream<List<HistoryEntity>> getHistories() =>
      remoteDataSource.getHistories();

  @override
  Future<void> assignEquipment(PickItemQueueData pickItemQueueData) async =>
      remoteDataSource.assignEquipment(pickItemQueueData);

  @override
  Future<void> dropItem(PickItemQueueData pickItemQueueData) async =>
      remoteDataSource.dropItem(pickItemQueueData);

  @override
  Future<void> pickupItem(PickItemQueueData pickItemQueueData) async =>
      remoteDataSource.pickupItem(pickItemQueueData);

  @override
  Future<void> removeForWaitingEquipment(PickItemQueueData pickItemQueueData) async =>
      remoteDataSource.removeForWaitingEquipment(pickItemQueueData);

  @override
  Future<void> waitingForEquipment(PickItemQueueData pickItemQueueData) async =>
      remoteDataSource.waitingForEquipment(pickItemQueueData);
  
  
}