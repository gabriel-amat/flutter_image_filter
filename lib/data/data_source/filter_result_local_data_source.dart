import 'package:flutter_image_filter/data/models/filter_result_model.dart';
import 'package:flutter_image_filter/objectbox.g.dart';

class FilterResultLocalDataSource {
  final Store store;
  late final Box<FilterResultModel> _box;

  FilterResultLocalDataSource({required this.store}) {
    _box = store.box<FilterResultModel>();
  }

  int save(FilterResultModel model) => _box.put(model);

  List<FilterResultModel> getAllSortedByTime() =>
      _box.query().order(FilterResultModel_.processingTimeMs).build().find();

  List<FilterResultModel> getHistoryByName(String language) =>
      _box
          .query(FilterResultModel_.language.equals(language))
          .order(FilterResultModel_.timestamp, flags: Order.descending)
          .build()
          .find();
}
