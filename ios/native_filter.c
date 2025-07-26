#include "native_filter.h"
#include <stdint.h>

__attribute__((visibility("default")))
void apply_gray_filter(uint8_t* pixels, int width, int height) {
    for (int i = 0; i < width * height * 4; i += 4) {
        uint8_t r = pixels[i];
        uint8_t g = pixels[i + 1];
        uint8_t b = pixels[i + 2];
        uint8_t gray = (r + g + b) / 3;

        pixels[i]     = gray;  // R
        pixels[i + 1] = gray;  // G
        pixels[i + 2] = gray;  // B
        // pixels[i + 3] = alpha (não mexe)
    }
}