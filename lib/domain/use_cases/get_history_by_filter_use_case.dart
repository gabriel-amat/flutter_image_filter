import 'package:flutter_image_filter/domain/entities/filter_result_entity.dart';
import 'package:flutter_image_filter/domain/repositories/i_filter_result_repository.dart';

class GetHistoryByFilterUseCase {
  final IFilterResultRepository repo;

  GetHistoryByFilterUseCase({required this.repo});

  List<FilterResultEntity> call(String language) =>
      repo.getHistoryByFilter(language: language);
}
