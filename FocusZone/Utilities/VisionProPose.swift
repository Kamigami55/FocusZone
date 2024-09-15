//
//  VisionProPose.swift
//  FocusZone
//
//  Created by Eason on 9/13/24.
//

import ARKit
import QuartzCore
import Combine

class VisionProPose: ObservableObject {
    
    let arkitSession = ARKitSession()
    let worldTracking = WorldTrackingProvider()
    
    func runARKitSession() async {
        do {
            try await arkitSession.run([worldTracking])
        } catch {
            print("Failed to run ARKit session: \(error)")
            return
        }
    }
    
    func stopARKitSession() {
        arkitSession.stop()
    }
    
    func queryDeviceRoll() async -> Double? {
        
        // Wait until the worldTracking state is running
        while worldTracking.state != .running {
            try? await Task.sleep(nanoseconds: 100_000_000) // 100 milliseconds
        }
        
        let deviceAnchor = worldTracking.queryDeviceAnchor(atTimestamp: CACurrentMediaTime())
        
        if let deviceAnchor = deviceAnchor {
            let transform = deviceAnchor.originFromAnchorTransform
            
            // Extract the elements for the 2x2 submatrix
            let m00 = transform.columns.0.x
            let m10 = transform.columns.1.x
            
            // Compute the rotation around the Z-axis
            let zRotation = atan2(m10, m00)
            
            // Convert the rotation to degrees and then to Double
            let zRotationDegrees = Double(zRotation * 180.0 / .pi)
            
            return zRotationDegrees
        } else {
            print("No device anchor found")
            return nil
        }
    }
}
