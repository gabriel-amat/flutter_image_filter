import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_filter/core/setup_dependencies.dart';
import 'package:flutter_image_filter/core/utils/enum/language_enum.dart';
import 'package:flutter_image_filter/domain/entities/filter_result_entity.dart';
import 'package:flutter_image_filter/presentation/controllers/leaderboard_controller.dart';
import 'package:flutter_image_filter/presentation/widgets/image_widget.dart';
import 'package:flutter_image_filter/service/pick_image_service.dart';
import 'package:image/image.dart' as img;

class SwiftFilterPage extends StatefulWidget {
  const SwiftFilterPage({super.key});

  @override
  State<SwiftFilterPage> createState() => _SwiftFilterPageState();
}

class _SwiftFilterPageState extends State<SwiftFilterPage> {
  final controller = locator.get<LeaderboardController>();
  static const platform = MethodChannel('com.example.image_filter/native');

  Uint8List? _originalImageBytes;
  Uint8List? _originalBytes;
  FilterResultEntity? filterResult;
  bool _loading = false;
  int _width = 0;
  int _height = 0;

  Future<void> _pickImage() async {
    final rawBytes = await PickImageService.pickImageFromCamera();
    if (rawBytes == null) return;

    final decoded = img.decodeImage(rawBytes)!;

    // Garante formato RGBA
    final rgbaImage = decoded.convert(format: img.Format.uint8, numChannels: 4);

    final rgbaBytes = rgbaImage.toUint8List();

    setState(() {
      _originalImageBytes = rawBytes;
      _originalBytes = rgbaBytes;
      filterResult = null;
      _width = rgbaImage.width;
      _height = rgbaImage.height;
    });
  }

  Future<void> _applyFilter() async {
    if (_originalBytes == null) return;

    setState(() => _loading = true);

    try {
      final result = await platform.invokeMethod('applyGrayscaleFilter', {
        'imageData': _originalBytes,
        'width': _width,
        'height': _height,
      });

      final filteredData = result['imageData'] as Uint8List;

      // Converte para formato de exibição
      final displayBytes = _convertRgbaToDisplayBytes(
        filteredData,
        _width,
        _height,
      );

      if (displayBytes == null) {
        return;
      }

      filterResult = FilterResultEntity(
        timestamp: DateTime.now(),
        imageBytes: displayBytes,
        processingTimeMs: result['processingTime'] as int,
        language: LanguageEnum.swift.name,
      );
      controller.addExecution(data: filterResult!);
      _loading = false;
      setState(() {});
    } on PlatformException catch (e) {
      debugPrint('Erro ao aplicar filtro Swift: ${e.message}');
      setState(() => _loading = false);
    }
  }

  Uint8List? _convertRgbaToDisplayBytes(
    Uint8List rgbaBytes,
    int width,
    int height,
  ) {
    try {
      final image = img.Image.fromBytes(
        width: width,
        height: height,
        bytes: rgbaBytes.buffer,
        format: img.Format.uint8,
        numChannels: 4,
      );

      return Uint8List.fromList(img.encodePng(image));
    } catch (e) {
      debugPrint('Erro ao converter para exibir: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Swift Filter Page'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            spacing: 8,
            children: [
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Tirar foto'),
                ),
              ),

              if (_originalImageBytes != null) ...[
                ImageWidget(imageBytesAsList: _originalImageBytes!),
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _applyFilter,
                    child: Text(
                      _loading ? 'Aplicando...' : 'Aplicar filtro cinza',
                    ),
                  ),
                ),
              ],

              if (filterResult != null && !_loading)
                ImageWidget(imageBytesAsList: filterResult!.imageBytes),

              if (_loading) CircularProgressIndicator(),

              if (filterResult != null)
                Text(
                  'Tempo de processamento Swift: ${filterResult!.processingTimeMs} ms',
                ),
            ],
          ),
        ),
      ),
    );
  }
}
