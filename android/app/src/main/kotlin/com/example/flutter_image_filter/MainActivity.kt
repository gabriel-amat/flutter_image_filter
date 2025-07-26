package com.example.flutter_image_filter

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Color
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import androidx.core.graphics.createBitmap
import androidx.core.graphics.get
import kotlinx.coroutines.*


data class FilterResult(
    val imageBytes: ByteArray,
    val processingTime: Long
) {
    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false

        other as FilterResult

        if (processingTime != other.processingTime) return false
        if (!imageBytes.contentEquals(other.imageBytes)) return false

        return true
    }

    override fun hashCode(): Int {
        var result = processingTime.hashCode()
        result = 31 * result + imageBytes.contentHashCode()
        return result
    }
}

class MainActivity: FlutterActivity() {
    private val channel = "flutter/image_filter"
    private val coroutineScope = CoroutineScope(Dispatchers.Default + Job())

    override fun onDestroy() {
        coroutineScope.cancel()
        super.onDestroy()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler { call, result ->
            if (call.method == "applyGrayFilter") {
                val byteArray = call.arguments as? ByteArray
                if (byteArray == null) {
                    result.error("INVALID", "Argumento inválido", null)
                    return@setMethodCallHandler
                }

                coroutineScope.launch(Dispatchers.Default) {
                    val filterResult = applyGrayFilter(byteArray)
                    withContext(Dispatchers.Main) {
                        if (filterResult != null) {
                            val resultMap = mapOf(
                                "imageBytes" to filterResult.imageBytes,
                                "processingTimeMs" to filterResult.processingTime
                            )
                            result.success(resultMap)
                        } else {
                            result.error("ERROR", "Erro ao processar a imagem", null)
                        }
                    }
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun applyGrayFilter(imageBytes: ByteArray): FilterResult? {
        val startTime = System.currentTimeMillis()

        // Decodifica os bytes em bitmap
        val originalBitmap = BitmapFactory.decodeByteArray(imageBytes, 0, imageBytes.size) ?: return null
        val width = originalBitmap.width
        val height = originalBitmap.height

        // Cria bitmap para saída
        val grayBitmap = originalBitmap.config?.let { createBitmap(width, height, it) }

        for (x in 0 until width) {
            for (y in 0 until height) {
                val pixel = originalBitmap[x, y]
                val r = Color.red(pixel)
                val g = Color.green(pixel)
                val b = Color.blue(pixel)

                // Media ponderada
                val gray = (0.299 * r + 0.587 * g + 0.114 * b).toInt()
                val newPixel = Color.rgb(gray, gray, gray)

                grayBitmap?.setPixel(x, y, newPixel)
            }
        }

        // Converte o bitmap filtrado para bytes PNG
        val outputStream = java.io.ByteArrayOutputStream()
        grayBitmap?.compress(Bitmap.CompressFormat.PNG, 100, outputStream)

        val endTime = System.currentTimeMillis()
        val processingTime = endTime - startTime

        return FilterResult(
            imageBytes = outputStream.toByteArray(),
            processingTime = processingTime
        )
    }
}
