import 'package:flutter_image_filter/core/utils/app_images.dart';

enum LanguageEnum {
  dart("Dart"),
  rust('Rust'),
  c("C"),
  kotlin('Kotlin'),
  swift('Swift');

  const LanguageEnum(this.name);

  final String name;
}

extension LanguageEnumString on String {
  String getLogoPath() => switch (this) {
    'Dart' => AppImages.dart,
    'Rust' => AppImages.rust,
    'C' => AppImages.c,
    'Kotlin' => AppImages.kotlin,
    'Swift' => AppImages.swift,
    String() => throw UnimplementedError(),
  };
}
