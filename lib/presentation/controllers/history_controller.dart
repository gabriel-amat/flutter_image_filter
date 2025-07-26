import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_filter/domain/use_cases/get_history_by_filter_use_case.dart';
import 'history_state.dart';

class HistoryController extends Cubit<HistoryState> {
  final GetHistoryByFilterUseCase getHistory;

  HistoryController({required this.getHistory}) : super(HistoryInitial());

  void load({required String language}) async {
    emit(HistoryLoading());
    try {
      final list = getHistory(language);
      emit(HistoryLoaded(list));
    } catch (e) {
      emit(HistoryError('Erro ao carregar histórico: $e'));
    }
  }
}
