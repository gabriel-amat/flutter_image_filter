import 'package:flutter_image_filter/data/models/filter_result_model.dart';
import 'package:flutter_image_filter/objectbox.g.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class LocalDataBaseObjectBox {
  final Store store;
  final Box<FilterResultModel> filterExecutionBox;

  LocalDataBaseObjectBox._create(this.store)
    : filterExecutionBox = store.box<FilterResultModel>();

  static Future<LocalDataBaseObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(
      directory: p.join(docsDir.path, "local-data-base"),
    );
    return LocalDataBaseObjectBox._create(store);
  }
}
