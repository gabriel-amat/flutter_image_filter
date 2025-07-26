import 'package:flutter_image_filter/domain/entities/filter_result_entity.dart';

abstract class IFilterResultRepository {
  void save({required FilterResultEntity data});

  List<FilterResultEntity> getFastestPerFilter();

  List<FilterResultEntity> getHistoryByFilter({required String language});
}
