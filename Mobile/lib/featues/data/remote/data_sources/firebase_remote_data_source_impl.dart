import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:veris_mobile/featues/data/remote/models/equipment_model.dart';
import 'package:veris_mobile/featues/data/remote/models/history_model.dart';
import 'package:veris_mobile/featues/data/remote/models/pick_item_queue_data.dart';
import 'package:veris_mobile/featues/data/remote/models/user_model.dart';
import 'package:veris_mobile/featues/domain/entities/equipment_entity.dart';
import 'package:veris_mobile/featues/domain/entities/history_entity.dart';
import 'package:veris_mobile/featues/domain/entities/user_entity.dart';
import 'package:veris_mobile/featues/presentation/widgets/common.dart';

import 'firebase_remote_data_source.dart';

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore fireStore;

  FirebaseRemoteDataSourceImpl({
    required this.auth,
    required this.fireStore,
  });

  @override
  Future<void> forgotPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }


  @override
  Future<String> getUid() async => auth.currentUser!.uid;

  @override
  Future<void> getUpdateUser(UserEntity user) async {
    Map<String, dynamic> userInformation = Map();

    final userCollection = fireStore.collection("users");

    if (user.profileUrl != null && user.profileUrl != "")
      userInformation['profileUrl'] = user.profileUrl;
    if (user.aboutMe != null && user.aboutMe != "")
      userInformation['aboutMe'] = user.aboutMe;
    if (user.phoneNumber != null && user.phoneNumber != "")
      userInformation["phoneNumber"] = user.phoneNumber;
    if (user.name != null && user.name != "")
      userInformation["name"] = user.name;

    userCollection.doc(user.uid).update(userInformation);
  }

  @override
  Stream<List<UserEntity>> getUsers() {
    final userCollection = fireStore.collection("users");
    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs
            .map((docSnapshot) => UserModel.fromSnapshot(docSnapshot))
            .toList());
  }

  @override
  Future<bool> isSignIn() async {
    return auth.currentUser?.uid != null;
  }

  @override
  Future<void> signIn(UserEntity user) async {
    await auth.signInWithEmailAndPassword(
        email: user.email!, password: user.password!);
  }

  @override
  Future<void> signOut() async {
    return await auth.signOut();
  }

  @override
  Future<void> signUp(UserEntity user) async {
    await auth.createUserWithEmailAndPassword(
        email: user.email!, password: user.password!);
  }


  @override
  Stream<List<EquipmentEntity>> getEquipments() {
    final userCollection = fireStore.collection("equipments");
    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs
            .map((docSnapshot) => EquipmentModel.fromSnapshot(docSnapshot))
            .toList());
  }

  @override
  Future<void> getUpdateEquipment(EquipmentEntity equipmentEntity) async {
    Map<String, dynamic> equipmentInformation = Map();

    final equipmentCollection = fireStore.collection("equipments");

    if (equipmentEntity.equipmentPhoto != null &&
        equipmentEntity.equipmentPhoto != "")
      equipmentInformation['equipmentPhoto'] = equipmentEntity.equipmentPhoto;
    if (equipmentEntity.name != null && equipmentEntity.name != "")
      equipmentInformation["name"] = equipmentEntity.name;
    if (equipmentEntity.quantity != null && equipmentEntity.quantity != -1)
      equipmentInformation["quantity"] = equipmentEntity.quantity;
    // if (equipmentEntity.pickupEquipment != null)
    if (equipmentEntity.isAvailable != null &&
        equipmentEntity.isAvailable != "")
      equipmentInformation["isAvailable"] = equipmentEntity.isAvailable;
    if (equipmentEntity.totalAvailableEquipment != null &&
        equipmentEntity.totalAvailableEquipment != -1)
      equipmentInformation["totalAvailableEquipment"] =
          equipmentEntity.totalAvailableEquipment;


    equipmentCollection.doc(equipmentEntity.equipmentId).update(
        equipmentInformation);
  }

  @override
  Future<void> getPickUpEquipment(EquipmentEntity equipmentEntity) async {
    final equipmentCollection = fireStore.collection("equipments").doc(
        equipmentEntity.equipmentId);

    final docRef = await equipmentCollection.get();

    List queue = docRef.get('queue');

    if (queue.contains(equipmentEntity.name) == true) {
      equipmentCollection.update({

        "queue": FieldValue.arrayRemove([equipmentEntity.name]),
        // "pickupEquipmentTime":FieldValue.arrayRemove([equipmentEntity.createdTime]),

      });
    } else {
      equipmentCollection.update({

        "queue": FieldValue.arrayUnion([equipmentEntity.name]),
        // "pickupEquipmentTime":FieldValue.arrayUnion([equipmentEntity.createdTime])

      });
    }
  }

  @override
  Future<void> getDropEquipment(EquipmentEntity equipmentEntity) async {
    final equipmentCollection = fireStore.collection("equipments").doc(
        equipmentEntity.equipmentId);

    final docRef = await equipmentCollection.get();

    List queue = docRef.get('waitingQueue');

    if (queue.contains(equipmentEntity.name) == true) {
      equipmentCollection.update({

        "waitingQueue": FieldValue.arrayRemove([equipmentEntity.name]),
        // "pickupEquipmentTime":FieldValue.arrayRemove([equipmentEntity.createdTime]),

      });
      Future.delayed(Duration(seconds: 1), () {
        toast("Remove Queue List.");
      });
    } else {
      equipmentCollection.update({

        "waitingQueue": FieldValue.arrayUnion([equipmentEntity.name]),


      });
      Future.delayed(Duration(seconds: 1), () {
        toast("Added Queue List.");
      });
    }
  }


  @override
  Future<void> pickupItem(PickItemQueueData pickItemQueueData) async {
    final equipmentCollection = fireStore.collection("equipments").doc(
        pickItemQueueData.equipmentId);

    final equipmentSnapshot = await equipmentCollection.get();

    if (equipmentSnapshot.exists) {

      List queue = equipmentSnapshot.get('queue');

      final pickupData = PickItemQueueData(
          time: Timestamp.now(),
          uid: pickItemQueueData.uid
      ).toDocument();
      print(queue.contains(pickItemQueueData.uid));
      equipmentCollection.update({
        "pickQueue": FieldValue.arrayUnion([pickupData]),
        "queue": FieldValue.arrayUnion([pickItemQueueData.uid]),
      });
      return;
    }

  }

  @override
  Future<void> dropItem(PickItemQueueData pickItemQueueData) async {
    final equipmentCollection = fireStore.collection("equipments").doc(
        pickItemQueueData.equipmentId);

    final equipmentSnapshot = await equipmentCollection.get();

    if (equipmentSnapshot.exists) {
      List<dynamic> equipmentPickupQueue = equipmentSnapshot.get('pickQueue');
      List queue = equipmentSnapshot.get('queue');

      equipmentPickupQueue.forEach((element) {
        if (element['uid'] == pickItemQueueData.uid) {
          equipmentCollection.update({
            "pickQueue": FieldValue.arrayRemove([element]),
            "queue": FieldValue.arrayRemove([pickItemQueueData.uid]),
          });
        }
      });


      return;
    }
    return;
  }

  @override
  Future<void> assignEquipment(PickItemQueueData pickItemQueueData) {
    // TODO: implement assignEquipment
    throw UnimplementedError();
  }

  @override
  Future<void> waitingForEquipment(PickItemQueueData pickItemQueueData) async{

    final equipmentCollection = fireStore.collection("equipments").doc(
        pickItemQueueData.equipmentId);

    final equipmentSnapshot = await equipmentCollection.get();

    if (equipmentSnapshot.exists) {

      List waitingQueue = equipmentSnapshot.get('waitingQueue');
      List waitingQueueId = equipmentSnapshot.get('waitingQueueId');

      final pickupData = PickItemQueueData(
          time: Timestamp.now(),
          uid: pickItemQueueData.uid
      ).toDocument();

      equipmentCollection.update({
        "waitingQueue": FieldValue.arrayUnion([pickupData]),
        "waitingQueueId": FieldValue.arrayUnion([pickItemQueueData.uid]),
      });
      return;
    }

  }

  @override
  Future<void> removeForWaitingEquipment(PickItemQueueData pickItemQueueData) async {

    final equipmentCollection = fireStore.collection("equipments").doc(
        pickItemQueueData.equipmentId);

    final equipmentSnapshot = await equipmentCollection.get();

    if (equipmentSnapshot.exists) {
      List waitingQueue = equipmentSnapshot.get('waitingQueue');
      List waitingQueueId = equipmentSnapshot.get('waitingQueueId');

      waitingQueue.forEach((element) {
        if (element['uid'] == pickItemQueueData.uid) {
          equipmentCollection.update({
            "waitingQueue": FieldValue.arrayRemove([element]),
            "waitingQueueId": FieldValue.arrayRemove([pickItemQueueData.uid]),
          });
        }
      });


      return;
    }
    return;

  }



  @override
  Future<void> addNewHistory(HistoryEntity history) async{
    final historyCollection = fireStore.collection("history");
    final historyId=historyCollection.doc().id;

    historyCollection.doc(historyId).get().then((userDoc) {
      final newUser = HistoryModel(
        name: history.name,
        time: history.time,
        actionDoneBy: history.actionDoneBy,
        event: history.event,
      ).toDocument();
      if (!userDoc.exists) {
        historyCollection.doc(historyId).set(newUser);
        return;
      }
      return;
    }).catchError((error) {
      print(error);
    });


  }

  @override
  Stream<List<HistoryEntity>> getHistories() {
    final userCollection = fireStore.collection("history");
    return userCollection.snapshots().map((querySnapshot) => querySnapshot.docs
        .map((docSnapshot) => HistoryModel.fromSnapshot(docSnapshot))
        .toList());
  }

}