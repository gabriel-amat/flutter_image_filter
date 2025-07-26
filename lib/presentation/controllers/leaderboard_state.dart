import 'package:flutter_image_filter/domain/entities/filter_result_entity.dart';

abstract class LeaderboardState {}

class LeaderboardInitial extends LeaderboardState {}

class LeaderboardLoading extends LeaderboardState {}

class LeaderboardLoaded extends LeaderboardState {
  final List<FilterResultEntity> list;

  LeaderboardLoaded(this.list);
}

class LeaderboardError extends LeaderboardState {
  final String message;
  
  LeaderboardError(this.message);
}
