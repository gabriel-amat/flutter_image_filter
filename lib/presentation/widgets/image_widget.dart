import 'dart:typed_data';

import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final List<int> imageBytesAsList;

  const ImageWidget({super.key, required this.imageBytesAsList});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.memory(Uint8List.fromList(imageBytesAsList), height: 200),
    );
  }
}
