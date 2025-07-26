import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_filter/core/utils/enum/language_enum.dart';
import 'package:flutter_image_filter/domain/entities/filter_result_entity.dart';
import 'package:uuid/uuid.dart';

import '../../../service/pick_image_service.dart';

class KotlinFilterPage extends StatefulWidget {
  const KotlinFilterPage({super.key});

  @override
  State<KotlinFilterPage> createState() => _KotlinFilterPageState();
}

class _KotlinFilterPageState extends State<KotlinFilterPage> {
  static const platform = MethodChannel('flutter/image_filter');
  Uint8List? _originalImageBytes;
  FilterResultEntity? filterResult;
  bool loading = false;

  Future<void> _pickImage() async {
    final rawBytes = await PickImageService.pickImageFromCamera();
    if (rawBytes == null) return;
    setState(() {
      _originalImageBytes = rawBytes;
      filterResult = null;
    });
  }

  Future<void> applyFilter() async {
    if (_originalImageBytes == null) return;

    try {
      setState(() => loading = true);
      final result = await platform.invokeMethod(
        'applyGrayFilter',
        _originalImageBytes,
      );

      filterResult = FilterResultEntity(
        timestamp: DateTime.now(),
        imageBytes: result['imageBytes'] as Uint8List,
        processingTimeMs: result['processingTimeMs'],
        language: LanguageEnum.kotlin.name,
      );

      loading = false;
      setState(() {});
    } on PlatformException catch (e) {
      debugPrint("Erro no filtro: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kotlin filter page'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: SingleChildScrollView(
          child: Column(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Tirar foto'),
                ),
              ),
              if (_originalImageBytes != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.memory(_originalImageBytes!, height: 250),
                ),

              if (_originalImageBytes != null)
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: loading ? null : applyFilter,
                    child: Text(
                      loading ? 'Aplicando...' : 'Aplicar filtro cinza',
                    ),
                  ),
                ),

              if (filterResult != null)
                loading
                    ? CircularProgressIndicator.adaptive()
                    : ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.memory(
                        filterResult!.imageBytes,
                        height: 250,
                      ),
                    ),
              if (filterResult != null)
                Text(
                  'Tempo de processamento em Kotlin: ${filterResult!.processingTimeMs}ms',
                ),
            ],
          ),
        ),
      ),
    );
  }
}
