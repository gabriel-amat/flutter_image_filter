import 'package:flutter_image_filter/data/data_source/filter_result_local_data_source.dart';
import 'package:flutter_image_filter/data/models/filter_result_model.dart';
import 'package:flutter_image_filter/domain/entities/filter_result_entity.dart';
import 'package:flutter_image_filter/domain/repositories/i_filter_result_repository.dart';

class FilterResultRepositoryImpl implements IFilterResultRepository {
  final FilterResultLocalDataSource dataSource;

  FilterResultRepositoryImpl({required this.dataSource});

  @override
  List<FilterResultEntity> getFastestPerFilter() {
    final list = dataSource.getAllSortedByTime();

    final Map<String, FilterResultModel> fastest = {};
    for (var model in list) {
      if (!fastest.containsKey(model.language) ||
          model.processingTimeMs < fastest[model.language]!.processingTimeMs) {
        fastest[model.language] = model;
      }
    }

    return fastest.values.map((m) => m.toEntity()).toList()
      ..sort((a, b) => a.processingTimeMs.compareTo(b.processingTimeMs));
  }

  @override
  List<FilterResultEntity> getHistoryByFilter({required String language}) {
    return dataSource
        .getHistoryByName(language)
        .map((e) => e.toEntity())
        .toList();
  }

  @override
  void save({required FilterResultEntity data}) {
    dataSource.save(FilterResultModel.fromEntity(data));
  }
}
