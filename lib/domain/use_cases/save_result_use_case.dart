import 'package:flutter_image_filter/domain/entities/filter_result_entity.dart';
import 'package:flutter_image_filter/domain/repositories/i_filter_result_repository.dart';

class SaveResultUseCase {
  final IFilterResultRepository repo;

  SaveResultUseCase({required this.repo});

  void call(FilterResultEntity data) => repo.save(data: data);
}
