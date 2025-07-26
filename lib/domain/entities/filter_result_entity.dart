import 'dart:typed_data';

class FilterResultEntity {
  int id;
  String language;
  Uint8List imageBytes;
  int processingTimeMs;
  DateTime timestamp;

  FilterResultEntity({
    this.id = 0,
    required this.language,
    required this.timestamp,
    required this.imageBytes,
    required this.processingTimeMs,
  });
}
