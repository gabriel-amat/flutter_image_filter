import 'package:flutter_image_filter/domain/entities/filter_result_entity.dart';
import 'package:flutter_image_filter/objectbox.g.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class LocalDataBaseObjectBox {
  final Store store;
  final Box<FilterResultEntity> filterExecutionBox;

  LocalDataBaseObjectBox._create(this.store)
    : filterExecutionBox = store.box<FilterResultEntity>();

  static Future<LocalDataBaseObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(
      directory: p.join(docsDir.path, "local-data-base"),
    );
    return LocalDataBaseObjectBox._create(store);
  }
}
