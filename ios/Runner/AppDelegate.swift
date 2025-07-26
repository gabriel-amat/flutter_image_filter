import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let controller = window?.rootViewController as! FlutterViewController
    let channelName = "com.example.image_filter/native"
    let imageFilterChannel = FlutterMethodChannel(
      name: channelName,
      binaryMessenger: controller.binaryMessenger
    )
    
    imageFilterChannel.setMethodCallHandler { (call, result) in
      self.handleMethodCall(call: call, result: result)
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func handleMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "applyGrayscaleFilter" {
      self.handleGrayscaleFilter(call: call, result: result)
    } else {
      result(FlutterMethodNotImplemented)
    }
  }
  
  private func handleGrayscaleFilter(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any] else {
      let error = FlutterError(
        code: "INVALID_ARGUMENTS",
        message: "Invalid arguments",
        details: nil
      )
      result(error)
      return
    }
    
    guard let imageData = args["imageData"] as? FlutterStandardTypedData,
          let width = args["width"] as? Int,
          let height = args["height"] as? Int else {
      let error = FlutterError(
        code: "INVALID_ARGUMENTS",
        message: "Missing required arguments",
        details: nil
      )
      result(error)
      return
    }
    
    // PROCESSAMENTO EM BACKGROUND THREAD
    DispatchQueue.global(qos: .userInitiated).async {
      let startTime = CFAbsoluteTimeGetCurrent()
      
      let filteredData = self.applyGrayscaleFilterOptimized(
        data: imageData.data,
        width: width,
        height: height
      )
      
      let endTime = CFAbsoluteTimeGetCurrent()
      let processingTime = Int((endTime - startTime) * 1000)
      
      let response: [String: Any] = [
        "imageData": FlutterStandardTypedData(bytes: filteredData),
        "processingTime": processingTime
      ]
      
      // Retorna resultado na main thread
      DispatchQueue.main.async {
        result(response)
      }
    }
  }
  
  private func applyGrayscaleFilterOptimized(data: Data, width: Int, height: Int) -> Data {
    var mutableData = data
    let totalPixels = width * height
    
    return mutableData.withUnsafeMutableBytes { bytes in
      let pixelBuffer = bytes.bindMemory(to: UInt32.self) //Usa UInt32 para processar 4 bytes por vez
      let byteBuffer = bytes.bindMemory(to: UInt8.self)
      
      DispatchQueue.concurrentPerform(iterations: totalPixels) { pixelIndex in
        let baseIndex = pixelIndex * 4
        
        let r = byteBuffer[baseIndex]
        let g = byteBuffer[baseIndex + 1]
        let b = byteBuffer[baseIndex + 2]
        
        let gray = UInt8((Int(r) * 77 + Int(g) * 150 + Int(b) * 29) >> 8)
        
        // 🎯 Atualização direta dos bytes
        byteBuffer[baseIndex] = gray
        byteBuffer[baseIndex + 1] = gray
        byteBuffer[baseIndex + 2] = gray
      }
      
      return Data(bytes: byteBuffer.baseAddress!, count: data.count)
    }
  }
  
}
