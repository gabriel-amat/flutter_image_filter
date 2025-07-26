class FilterResultEntity {
  int id;
  String language;
  List<int> imageBytes;
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
