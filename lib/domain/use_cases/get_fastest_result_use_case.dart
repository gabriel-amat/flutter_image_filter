import 'package:flutter_image_filter/domain/entities/filter_result_entity.dart';
import 'package:flutter_image_filter/domain/repositories/i_filter_result_repository.dart';

class GetFastestPerFilterUseCase {
  final IFilterResultRepository repo;

  GetFastestPerFilterUseCase({required this.repo});

  List<FilterResultEntity> call() => repo.getFastestPerFilter();
}
