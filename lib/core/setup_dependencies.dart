import 'package:flutter_image_filter/data/data_source/filter_result_local_data_source.dart';
import 'package:flutter_image_filter/data/repositories/filter_result_repository_impl.dart';
import 'package:flutter_image_filter/domain/repositories/i_filter_result_repository.dart';
import 'package:flutter_image_filter/domain/use_cases/get_fastest_result_use_case.dart';
import 'package:flutter_image_filter/domain/use_cases/get_history_by_filter_use_case.dart';
import 'package:flutter_image_filter/domain/use_cases/save_result_use_case.dart';
import 'package:flutter_image_filter/main.dart';
import 'package:flutter_image_filter/presentation/controllers/history_controller.dart';
import 'package:flutter_image_filter/presentation/controllers/leaderboard_controller.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupDependencies() {
  locator.registerLazySingleton<FilterResultLocalDataSource>(
    () => FilterResultLocalDataSource(store: localDataBase.store),
  );

  locator.registerLazySingleton<IFilterResultRepository>(
    () => FilterResultRepositoryImpl(dataSource: locator.get()),
  );

  locator.registerLazySingleton<GetFastestPerFilterUseCase>(
    () => GetFastestPerFilterUseCase(repo: locator.get()),
  );

  locator.registerLazySingleton<GetHistoryByFilterUseCase>(
    () => GetHistoryByFilterUseCase(repo: locator.get()),
  );

  locator.registerLazySingleton<SaveResultUseCase>(
    () => SaveResultUseCase(repo: locator.get()),
  );

  locator.registerLazySingleton<HistoryController>(
    () => HistoryController(getHistory: locator.get()),
  );

  locator.registerLazySingleton<LeaderboardController>(
    () => LeaderboardController(
      getFastest: locator.get(),
      saveExecution: locator.get(),
    ),
  );
}
