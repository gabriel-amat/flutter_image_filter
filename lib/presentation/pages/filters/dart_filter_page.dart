import 'dart:ui' as ui;
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_filter/core/utils/enum/language_enum.dart';
import 'package:flutter_image_filter/domain/entities/filter_result_entity.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/entities/gray_filter_param.dart';

Uint8List applyGrayFilter(GrayFilterParams params) {
  for (int i = 0; i < params.pixels.length; i += 4) {
    final r = params.pixels[i];
    final g = params.pixels[i + 1];
    final b = params.pixels[i + 2];

    final gray = (0.299 * r + 0.587 * g + 0.114 * b).round();

    params.pixels[i] = gray;
    params.pixels[i + 1] = gray;
    params.pixels[i + 2] = gray;
    // Alpha fica como está
  }

  return params.pixels;
}

class DartFilterPage extends StatefulWidget {
  const DartFilterPage({super.key});

  @override
  State<DartFilterPage> createState() => _DartFilterPageState();
}

class _DartFilterPageState extends State<DartFilterPage> {
  Uint8List? _originalImageBytes;
  FilterResultEntity? filterResult;
  bool _loading = false;

  Future<void> pickImageFromCamera() async {
    final XFile? photo = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (photo == null) return;

    //Imagem codificada (JPEG/PNG comprimido)
    final bytes = await photo.readAsBytes();

    setState(() => _originalImageBytes = bytes);
  }

  Future<void> applyFilter() async {
    setState(() => _loading = true);
    final codec = await ui.instantiateImageCodec(_originalImageBytes!);
    final frame = await codec.getNextFrame();
    final uiImage = frame.image;

    final byteDataReq = await uiImage.toByteData(
      format: ui.ImageByteFormat.rawRgba,
    );
    if (byteDataReq == null) return;

    //Imagem decodificada em pixels RGBA
    //Uint8List representa qualquer dado binario, compactado ou nao, por isso parece a mesma coisa
    // que a linha 29, mas nao é
    final pixelBytes = byteDataReq.buffer.asUint8List();

    // Envia para o Isolate
    final stopwatch = Stopwatch()..start();
    final grayImage = await compute(
      applyGrayFilter,
      GrayFilterParams(pixelBytes, uiImage.width, uiImage.height),
    );
    stopwatch.stop();
    final processingTime = stopwatch.elapsedMilliseconds;

    // ui.Image é feito na thread principal
    final img = await decodeImageFromPixelsAsync(
      grayImage,
      uiImage.width,
      uiImage.height,
    );
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final grayImagePngBytes = byteData!.buffer.asUint8List();

    filterResult = FilterResultEntity(
      imageBytes: grayImagePngBytes,
      language: LanguageEnum.dart.name,
      processingTimeMs: processingTime,
      timestamp: DateTime.now(),
    );
    _loading = false;
    setState(() {});
  }

  Future<ui.Image> decodeImageFromPixelsAsync(
    Uint8List pixels,
    int width,
    int height,
  ) {
    final completer = Completer<ui.Image>();

    ui.decodeImageFromPixels(
      pixels,
      width,
      height,
      ui.PixelFormat.rgba8888,
      completer.complete,
    );

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dart filter page'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: SingleChildScrollView(
          child: Column(
            spacing: 16,
            children: [
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: pickImageFromCamera,
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
                    onPressed: _loading ? null : applyFilter,
                    child: Text(
                      _loading ? 'Aplicando...' : 'Aplicar filtro cinza',
                    ),
                  ),
                ),

              if (filterResult != null)
                _loading
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
                  'Tempo de processamento em Dart: ${filterResult!.processingTimeMs}ms',
                ),
            ],
          ),
        ),
      ),
    );
  }
}
