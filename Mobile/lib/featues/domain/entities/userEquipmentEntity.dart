

import 'package:veris_mobile/featues/domain/entities/equipment_entity.dart';
import 'package:veris_mobile/featues/domain/entities/user_entity.dart';

class UserEquipmentEntity{
  final UserEntity user;
  final EquipmentEntity equipment;

  UserEquipmentEntity({required this.user, required this.equipment});
}