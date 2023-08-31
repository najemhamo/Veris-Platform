part of 'history_cubit.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();
}

class HistoryInitial extends HistoryState {
  @override
  List<Object> get props => [];
}
class HistoryLoading extends HistoryState {
  @override
  List<Object> get props => [];
}
class HistoryLoaded extends HistoryState {
  final List<HistoryEntity> historyData;

  const HistoryLoaded({required this.historyData});
  @override
  List<Object> get props => [historyData];
}
class HistoryFailure extends HistoryState {
  @override
  List<Object> get props => [];
}



