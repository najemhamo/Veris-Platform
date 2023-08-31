part of 'equipment_cubit.dart';

abstract class EquipmentState extends Equatable {
  const EquipmentState();
}

class EquipmentInitial extends EquipmentState {
  @override
  List<Object> get props => [];
}
class EquipmentLoading extends EquipmentState {
  @override
  List<Object> get props => [];
}
class EquipmentFailure extends EquipmentState {
  @override
  List<Object> get props => [];
}
class EquipmentLoaded extends EquipmentState {
  final List<EquipmentEntity> equipments;

  EquipmentLoaded({required this.equipments});
  @override
  List<Object> get props => [equipments];
}
