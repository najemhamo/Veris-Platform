import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:veris/features/domain/entities/history_entity.dart';
import 'package:veris/features/domain/use_cases/add_new_history_usecase.dart';
import 'package:veris/features/domain/use_cases/get_histories_usecase.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final GetHistoriesUseCase getHistoriesUseCase;
  final AddNewHistoryUseCase addNewHistoryUseCase;
  HistoryCubit({required this.getHistoriesUseCase,required this.addNewHistoryUseCase}) : super(HistoryInitial());



  Future<void> getHistories()async{
    emit(HistoryLoading());
    try{
      final streamResponse= getHistoriesUseCase.call();
      streamResponse.listen((histories) {
        emit(HistoryLoaded(historyData: histories));
      });
    }on SocketException catch(_){
      emit(HistoryFailure());
    }catch(_){
      emit(HistoryFailure());
    }
  }

  Future<void> addNewEquipments({required HistoryEntity equipmentEntity})async{
    try{
      await addNewHistoryUseCase.call(equipmentEntity);
    }on SocketException catch(_){
      emit(HistoryFailure());
    }catch(_){
      emit(HistoryFailure());
    }
  }

}
