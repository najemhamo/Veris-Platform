import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:veris_mobile/featues/domain/entities/equipment_entity.dart';


class EquipmentModel extends EquipmentEntity {
  EquipmentModel({
    final String? name,
    final String? equipmentPhoto,
    final String? equipmentId,
    final int? quantity,
    final String? isAvailable,
    final bool? pickupEquipment,
    final int? totalAvailableEquipment,
    final Timestamp? createdTime,
    final String? shelf,
    final String? description,
    final List<String>? queue,
    final List<Map<String,dynamic>>? pickQueue,
    final List<Map<String,dynamic>>? waitingQueue,
    final List<String>? waitingQueueId,
    final List<Timestamp>? pickupEquipmentTime,
  }) : super(
            name: name,
            equipmentPhoto: equipmentPhoto,
            equipmentId: equipmentId,
            quantity: quantity,
            isAvailable: isAvailable,
            pickupEquipment: pickupEquipment,
            totalAvailableEquipment: totalAvailableEquipment,
            createdTime: createdTime,
            shelf: shelf,
            description: description,
            queue: queue,
            pickQueue: pickQueue,
            waitingQueue: waitingQueue,
            waitingQueueId: waitingQueueId,
            pickupEquipmentTime: pickupEquipmentTime,
  );

  factory EquipmentModel.fromSnapshot(DocumentSnapshot snapshot) {
    return EquipmentModel(
      name: snapshot.get('name'),
      equipmentPhoto: snapshot.get('equipmentPhoto'),
      equipmentId: snapshot.get('equipmentId'),
      quantity: snapshot.get('quantity'),
      isAvailable: snapshot.get('isAvailable'),
      pickupEquipment: snapshot.get('pickupEquipment'),
      totalAvailableEquipment: snapshot.get('totalAvailableEquipment'),
      createdTime: snapshot.get('createdTime'),
      shelf: snapshot.get('shelf'),
      description: snapshot.get('description'),
      queue: List.from(snapshot.get('queue')),
      pickQueue: List.from(snapshot.get('pickQueue')),
      waitingQueue: List.from(snapshot.get('waitingQueue')),
      waitingQueueId: List.from(snapshot.get('waitingQueueId')),
      pickupEquipmentTime: List.from(snapshot.get('pickupEquipmentTime')),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "name": name,
      "equipmentPhoto": equipmentPhoto,
      "equipmentId": equipmentId,
      "quantity": quantity,
      "isAvailable": isAvailable,
      "pickupEquipment": pickupEquipment,
      "totalAvailableEquipment": totalAvailableEquipment,
      "createdTime": createdTime,
      "shelf": shelf,
      "description": description,
      "queue": queue,
      "pickQueue": pickQueue,
      "waitingQueue": waitingQueue,
      "waitingQueueId": waitingQueueId,
      "pickupEquipmentTime": pickupEquipmentTime,
    };
  }
}
