import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class HistoryEntity extends Equatable {
  final String? name;
  final String? event;
  final String? actionDoneBy;
  final Timestamp? time;

  HistoryEntity({
    this.name,
    this.event,
    this.actionDoneBy,
    this.time,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    name,
    event,
    actionDoneBy,
    time,
  ];
}
