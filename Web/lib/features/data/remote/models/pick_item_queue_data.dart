

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class PickItemQueueData extends Equatable{

  final String? uid;
  final String? equipmentId;
  final Timestamp? time;

  PickItemQueueData({this.uid,this.equipmentId, this.time});

  @override
  List<Object?> get props => [uid,equipmentId,time];


  factory PickItemQueueData.fromSnapshot(DocumentSnapshot snapshot) {
    return PickItemQueueData(
      uid: snapshot.get('uid'),
      time: snapshot.get('time'),
    );
  }


  Map<String, dynamic> toDocument() {
    return {
      "uid": uid,
      "time": time,
    };
  }
}