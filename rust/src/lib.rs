 #[unsafe(no_mangle)]
pub extern "C" fn apply_gray_filter(ptr: *mut u8, width: i32, height: i32) {
    let len = (width as usize) * (height as usize) * 4;

    let pixels = unsafe { std::slice::from_raw_parts_mut(ptr, len) };

    for i in (0..len).step_by(4) {
        let r = pixels[i] as f32;
        let g = pixels[i + 1] as f32;
        let b = pixels[i + 2] as f32;

        let gray = (0.3 * r + 0.59 * g + 0.11 * b) as u8;

        pixels[i] = gray;
        pixels[i + 1] = gray;
        pixels[i + 2] = gray;
        // Alpha (pixels[i + 3]) permanece
    }
}