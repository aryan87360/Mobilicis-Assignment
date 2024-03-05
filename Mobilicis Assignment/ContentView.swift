//
//  ContentView.swift
//  Mobilicis Assignment
//
//  Created by Aryan Sharma on 05/03/24.
//

import SwiftUI
import AVFoundation

struct BatteryInfoView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Battery Health: \(BatteryHelper().batteryHealth)")
            Text("Battery Level: \(BatteryHelper().batteryLevel * 100)%")
        }
        .eraseToAnyView()
    }
}

struct CameraInfoView: View {
    var body: some View {
        Group {
            if let camera = AVCaptureDevice.default(for: .video) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Camera: \(camera.localizedName), \(camera.activeFormat.maxExposureDuration.seconds) seconds, \(camera.activeFormat.videoFieldOfView) degrees")
                }
            } else {
                Text("Camera information not available")
            }
        }
        .eraseToAnyView()
    }
}

class BatteryHelper {
    var batteryHealth: String {
        return UIDevice.current.batteryState == .unknown ? "Unknown" : "\(UIDevice.current.batteryLevel * 100)%"
    }

    var batteryLevel: Float {
        return UIDevice.current.batteryLevel
    }
}

class Sysctl {
    class func sysctl(_ key: String) -> String? {
        var size = 0
        sysctlbyname(key, nil, &size, nil, 0)
        var value = [CChar](repeating: 0, count: size)
        sysctlbyname(key, &value, &size, nil, 0)
        return String(cString: value)
    }

    static var model: String {
        return sysctl("hw.model") ?? "N/A"
    }

    static var gpuModel: String {
        return sysctl("hw.model") ?? "N/A"
    }
}

extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}


struct ContentView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Model: \(UIDevice.current.model)")
            Text("iOS Version: \(UIDevice.current.systemVersion)")
            Text("Serial Number: \(UIDevice.current.identifierForVendor?.uuidString ?? "N/A")")
            

            // Storage Information
            if let totalSpace = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())[.systemSize] as? NSNumber,
               let freeSpace = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())[.systemFreeSize] as? NSNumber {
                Text("Storage: \(formatFileSize(totalSpace.int64Value)) total, \(formatFileSize(freeSpace.int64Value)) free")
            } else {
                Text("Storage information not available")
            }
            
            Text("Screen Size: \(String(describing: UIScreen.main.bounds.size))")
            Text("Screen Resolution: \(Int(UIScreen.main.nativeBounds.width)) x \(Int(UIScreen.main.nativeBounds.height))")
            
            BatteryInfoView()

            CameraInfoView()

            Text("Processor: \(Sysctl.model)")

            Text("GPU: \(Sysctl.gpuModel)")

            // IMEI is not accessible directly in iOS due to privacy restrictions
            Text("IMEI: Dial *#06# for IMEI information.")
            
            
        }
        .padding()
    }

    func formatFileSize(_ size: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useGB, .useMB]
        formatter.countStyle = .binary
        return formatter.string(fromByteCount: size)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



