#ifndef NATIVE_FILTER_H
#define NATIVE_FILTER_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

__attribute__((visibility("default")))
void apply_gray_filter(uint8_t* pixels, int width, int height);

#ifdef __cplusplus
}
#endif

#endif