import 'package:flutter_image_filter/domain/entities/filter_result_entity.dart';

abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<FilterResultEntity> list;

  HistoryLoaded(this.list);
}

class HistoryError extends HistoryState {
  final String message;
  
  HistoryError(this.message);
}
