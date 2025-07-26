import 'dart:ffi'; // -> ponteiros e bibliotecas (codigo nativo)
import 'dart:io';
import 'dart:typed_data'; // -> Uint8List
import 'package:ffi/ffi.dart'; // -> memoria
import 'package:flutter/material.dart';
import 'package:flutter_image_filter/core/setup_dependencies.dart';
import 'package:flutter_image_filter/core/utils/enum/language_enum.dart';
import 'package:flutter_image_filter/domain/entities/filter_result_entity.dart';
import 'package:flutter_image_filter/presentation/controllers/leaderboard_controller.dart';
import 'package:flutter_image_filter/presentation/widgets/image_widget.dart';
import 'package:image/image.dart' as img;

import '../../../service/pick_image_service.dart';

final nativeLib =
    Platform.isAndroid
        ? DynamicLibrary.open("librust.so")
        : DynamicLibrary.process();

// Definição do tipo da função C/Rust
typedef GrayscaleFilterNative = Void Function(Pointer<Uint8>, Int32, Int32);
typedef GrayscaleFilterDart = void Function(Pointer<Uint8>, int, int);

// Lookup da função
final grayscaleFilter = nativeLib
    .lookupFunction<GrayscaleFilterNative, GrayscaleFilterDart>(
      'apply_gray_filter',
    );

class RustFilterPage extends StatefulWidget {
  const RustFilterPage({super.key});

  @override
  State<RustFilterPage> createState() => _RustFilterPageState();
}

class _RustFilterPageState extends State<RustFilterPage> {
  final controller = locator.get<LeaderboardController>();
  Uint8List? _originalBytes; // <- Para processamento C (RGBA)
  FilterResultEntity? filterResult;
  Uint8List? _originalImageBytes; // <- Para exibição (JPEG/PNG)
  bool _loading = false;
  int _width = 0;
  int _height = 0;

  Future<void> _pickImage() async {
    final rawBytes = await PickImageService.pickImageFromCamera();
    if (rawBytes == null) return;

    final decoded = img.decodeImage(rawBytes)!;

    // Garante que a imagem seja RGBA de 8 bits
    final rgbaImage = decoded.convert(format: img.Format.uint8, numChannels: 4);

    final rgbaBytes = rgbaImage.getBytes(); // Bytes descompactados

    setState(() {
      _originalImageBytes = rawBytes;
      _originalBytes = rgbaBytes;
      filterResult = null;
      _width = decoded.width;
      _height = decoded.height;
    });
  }

  Future<void> _applyFilter() async {
    if (_originalBytes == null) return;

    setState(() => _loading = true);

    try {
      final bytesLength = _originalBytes!.length;
      final expectedLength = _width * _height * 4; // RGBA

      if (bytesLength != expectedLength) {
        setState(() => _loading = false);
        return;
      }

      // Aloca memória nativa
      final Pointer<Uint8> nativeBuffer = malloc.allocate<Uint8>(bytesLength);

      // Copia os bytes para memória nativa
      final nativeList = nativeBuffer.asTypedList(bytesLength);
      nativeList.setAll(0, _originalBytes!);

      final stopwatch = Stopwatch()..start();

      // Chama a função C
      debugPrint('Chamando função C criada em Rust...');
      grayscaleFilter(nativeBuffer, _width, _height);
      debugPrint('Função C criada em Rust executada!');

      stopwatch.stop();

      // Copia resultado de volta
      //Aqui os bytes nao estao compactados
      final filteredBytes = Uint8List.fromList(nativeList);

      // Libera memória nativa
      malloc.free(nativeBuffer);

      // Compacta de volta os bytes para exibição
      final displayBytes = _convertRgbaToDisplayBytes(
        filteredBytes,
        _width,
        _height,
      );

      if (displayBytes == null) {
        return;
      }

      filterResult = FilterResultEntity(
        timestamp: DateTime.now(),
        imageBytes: displayBytes,
        processingTimeMs: stopwatch.elapsedMilliseconds,
        language: LanguageEnum.rust.name,
      );
      controller.addExecution(data: filterResult!);
      _loading = false;
      setState(() {});
    } catch (e) {
      debugPrint('Erro ao aplicar filtro: $e');
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

      // Converte para PNG
      return Uint8List.fromList(img.encodePng(image));
    } catch (e) {
      debugPrint('Erro ao converter para exibição: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filtro em Rust via FFI'),
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

              if (_originalBytes != null) ...[
                ImageWidget(imageBytesAsList: _originalImageBytes!),
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _applyFilter,
                    child: Text(
                      _loading ? 'Processando...' : 'Aplicar filtro cinza',
                    ),
                  ),
                ),
              ],

              if (filterResult != null && !_loading) ...[
                ImageWidget(imageBytesAsList: filterResult!.imageBytes),
              ],
              if (_loading) CircularProgressIndicator(),

              if (filterResult != null)
                Text(
                  'Tempo de processamento: ${filterResult!.processingTimeMs} ms',
                ),
            ],
          ),
        ),
      ),
    );
  }
}
