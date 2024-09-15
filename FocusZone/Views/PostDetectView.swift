//
//  PostDetectView.swift
//  FocusZone
//
//  Created by Eason on 9/13/24.
//

import SwiftUI
import RealityKit

struct PostDetectView: View {
    
    // Load vision pro pose
    @StateObject private var visionProPose = VisionProPose()
    
    var body: some View {
        RealityView { content in
            
            // Run each time scene is drawn (90Hz)
            _ =  content.subscribe(to: SceneEvents.Update.self) { event in
                
                Task {
//                    print("starting post detection")
                    if let currentHeadRoll = await visionProPose.queryDeviceRoll() {
//                        print("currentHeadRoll: \(currentHeadRoll)")
                        // Head roll is more than 14 degrees in either direction
                        if abs(currentHeadRoll) > 14 {
                            
                            // Default to left
                            var tiltDirection = "left"
                            
                            // But could be right
                            if currentHeadRoll > 14 {
                                tiltDirection = "right"
                            }
                            
                            // Do something with head tilt
                            switch tiltDirection {
                            case "left":
                                print("Head tilting left!")
                            case "right":
                                print("Head tilting right!")
                            default:
                                break
                            }
                        }
                    }
                }
            }
        }.onAppear() {
            Task {
                await visionProPose.runARKitSession()
                print("Post Detect View Appeared")
            }
        }
    }
}
