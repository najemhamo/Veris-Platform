import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:veris_mobile/featues/domain/entities/history_entity.dart';


class HistoryModel extends HistoryEntity {
  HistoryModel({
    final String? name,
    final String? event,
    final String? actionDoneBy,
    final Timestamp? time,
  }) : super(
      time: time,
    name: name,
    actionDoneBy: actionDoneBy,
    event: event,
        );

  factory HistoryModel.fromSnapshot(DocumentSnapshot snapshot) {
    return HistoryModel(
      name: snapshot.get('name'),
      event: snapshot.get('event'),
      actionDoneBy: snapshot.get('actionDoneBy'),
      time: snapshot.get('time'),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "name": name,
      "event": event,
      "actionDoneBy": actionDoneBy,
      "time": time,

    };
  }
}
