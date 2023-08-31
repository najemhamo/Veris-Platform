import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:veris_mobile/featues/data/remote/models/pick_item_queue_data.dart';
import 'package:veris_mobile/featues/domain/entities/equipment_entity.dart';
import 'package:veris_mobile/featues/domain/use_cases/get_drop_equipment_usecase.dart';
import 'package:veris_mobile/featues/domain/use_cases/get_equipments_usecase.dart';
import 'package:veris_mobile/featues/domain/use_cases/get_pickup_equipment_usecase.dart';
import 'package:veris_mobile/featues/domain/use_cases/get_remove_for_waiting_equipment_usecase.dart';
import 'package:veris_mobile/featues/domain/use_cases/get_update_equipment_usecase.dart';
import 'package:veris_mobile/featues/domain/use_cases/get_waiting_for_equipment_usecase.dart';

part 'equipment_state.dart';

class EquipmentCubit extends Cubit<EquipmentState> {
  final GetUpdateEquipmentUseCase getUpdateEquipmentUseCase;
  final GetEquipmentsUseCase getEquipmentsUseCase;
  final GetPickUpEquipmentUseCase getPickUpEquipmentUseCase;
  final GetDropEquipmentUseCase getDropEquipmentUseCase;
  final GetWaitingForEquipmentUseCase getWaitingForEquipmentUseCase;
  final GetRemoveForWaitingEquipmentUseCase getRemoveForWaitingEquipmentUseCase;

  EquipmentCubit({
    required this.getDropEquipmentUseCase,
    required this.getUpdateEquipmentUseCase,
    required this.getEquipmentsUseCase,
    required this.getPickUpEquipmentUseCase,
    required this.getWaitingForEquipmentUseCase,
    required this.getRemoveForWaitingEquipmentUseCase,
  }) : super(EquipmentInitial());

  Future<void> getEquipments() async {
    emit(EquipmentLoading());
    try {
      final streamResponse = getEquipmentsUseCase.call();
      streamResponse.listen((equipments) {
        emit(EquipmentLoaded(equipments: equipments));
      });
    } on SocketException catch (_) {
      emit(EquipmentFailure());
    } catch (_) {
      emit(EquipmentFailure());
    }
  }

  Future<void> updateEquipments(
      {required EquipmentEntity equipmentEntity}) async {
    try {
      await getUpdateEquipmentUseCase.call(equipmentEntity);
    } on SocketException catch (_) {
      emit(EquipmentFailure());
    } catch (_) {
      emit(EquipmentFailure());
    }
  }

  Future<void> getPickUpEquipments(
      {required PickItemQueueData pickItemQueueData}) async {
    try {
      await getPickUpEquipmentUseCase.call(pickItemQueueData);
    } on SocketException catch (_) {
      emit(EquipmentFailure());
    } catch (_) {
      emit(EquipmentFailure());
    }
  }
  Future<void> getDropEquipments(
      {required PickItemQueueData pickItemQueueData}) async {
    try {
      await getDropEquipmentUseCase.call(pickItemQueueData);
    } on SocketException catch (_) {
      emit(EquipmentFailure());
    } catch (_) {
      emit(EquipmentFailure());
    }
  }
  Future<void> getWaitingForEquipments(
      {required PickItemQueueData pickItemQueueData}) async {
    try {
      await getWaitingForEquipmentUseCase.call(pickItemQueueData);
    } on SocketException catch (_) {
      emit(EquipmentFailure());
    } catch (_) {
      emit(EquipmentFailure());
    }
  }
  Future<void> getRemoveForWaitingEquipments(
      {required PickItemQueueData pickItemQueueData}) async {
    try {
      await getRemoveForWaitingEquipmentUseCase.call(pickItemQueueData);
    } on SocketException catch (_) {
      emit(EquipmentFailure());
    } catch (_) {
      emit(EquipmentFailure());
    }
  }
}
