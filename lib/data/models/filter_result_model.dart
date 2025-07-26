import 'package:flutter_image_filter/domain/entities/filter_result_entity.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class FilterResultModel {
  int id;
  String language;
  List<int> imageBytes;
  int processingTimeMs;
  DateTime timestamp;

  FilterResultModel({
    this.id = 0,
    required this.language,
    required this.timestamp,
    required this.imageBytes,
    required this.processingTimeMs,
  });

  factory FilterResultModel.fromEntity(FilterResultEntity e) {
    return FilterResultModel(
      id: e.id,
      language: e.language,
      imageBytes: e.imageBytes,
      processingTimeMs: e.processingTimeMs,
      timestamp: e.timestamp,
    );
  }

  FilterResultEntity toEntity() {
    return FilterResultEntity(
      id: id,
      timestamp: timestamp,
      language: language,
      imageBytes: imageBytes,
      processingTimeMs: processingTimeMs,
    );
  }
}
