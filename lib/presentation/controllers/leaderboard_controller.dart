import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_filter/domain/entities/filter_result_entity.dart';
import 'package:flutter_image_filter/domain/use_cases/get_fastest_result_use_case.dart';
import 'package:flutter_image_filter/domain/use_cases/save_result_use_case.dart';
import 'leaderboard_state.dart';

class LeaderboardController extends Cubit<LeaderboardState> {
  final GetFastestPerFilterUseCase getFastest;
  final SaveResultUseCase saveExecution;

  LeaderboardController({required this.getFastest, required this.saveExecution})
    : super(LeaderboardInitial());

  void load() async {
    emit(LeaderboardLoading());
    try {
      final list = getFastest();
      emit(LeaderboardLoaded(list));
    } catch (e) {
      emit(LeaderboardError('Erro ao carregar leaderboard: $e'));
    }
  }

  Future<void> addExecution(FilterResultEntity execution) async {
    saveExecution(execution);
    load();
  }
}
