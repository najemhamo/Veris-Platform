

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class EquipmentEntity extends Equatable{
  final String? name;
  final String? equipmentPhoto;
  final String? equipmentId;
  final int? quantity;
  final String? isAvailable;
  final bool? pickupEquipment;
  final int? totalAvailableEquipment;
  final Timestamp? createdTime;
  final String? shelf;
  final String? description;
  final List<String>? queue;
  final List<Map<String,dynamic>>? pickQueue;
  final List<Map<String,dynamic>>? waitingQueue;
  final List<String>? waitingQueueId;
  final List<Timestamp>? pickupEquipmentTime;

  EquipmentEntity({
    this.name,
    this.equipmentPhoto,
    this.equipmentId,
    this.quantity,
    this.isAvailable,
    this.pickupEquipment,
    this.totalAvailableEquipment,
    this.createdTime,
    this.shelf,
    this.description,
    this.queue,
    this.pickQueue,
    this.waitingQueue,
    this.waitingQueueId,
    this.pickupEquipmentTime,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    name,
    equipmentPhoto,
    equipmentId,
    quantity,
    isAvailable,
    pickupEquipment,
    totalAvailableEquipment,
    createdTime,
    shelf,
    description,
    queue,
    pickQueue,
    waitingQueue,
    waitingQueueId,
    pickupEquipmentTime,
  ];


}
