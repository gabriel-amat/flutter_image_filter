import 'dart:typed_data';

class GrayFilterParams {
  final Uint8List pixels;
  final int width;
  final int height;

  GrayFilterParams(this.pixels, this.width, this.height);
}
