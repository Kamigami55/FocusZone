//
//  PostDetectView.swift
//  FocusZone
//
//  Created by Eason on 9/13/24.
//

import SwiftUI
import RealityKit

struct PostDetectView: View {
    @Environment(AppState.self) private var appState

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
                            // Tilt left or right
                            if (
                                !appState.isShowingDistractionAlert
                                && (
                                    appState.lastDistractionTime == nil || Date() > (appState.lastDistractionTime?
                                        .addingTimeInterval(5))!
                                )
                            ) {
                                appState.activeDistraction = .headMovement
                                appState.isShowingDistractionAlert = true
                            }
//                            // Default to left
//                            var tiltDirection = "left"
//                            
//                            // But could be right
//                            if currentHeadRoll > 14 {
//                                tiltDirection = "right"
//                            }
//                            
//                            // Do something with head tilt
//                            switch tiltDirection {
//                            case "left":
//                                print("Head tilting left!")
//                            case "right":
//                                print("Head tilting right!")
//                            default:
//                                break
//                            }
                        }
                    }
                }
            }
        }.onAppear() {
            Task {
                // Head movement detector
                await visionProPose.runARKitSession()
                print("Head movement started")
                
                // Sound detector
                appState.soundLevelDetector.onExceedThreshold = { level in
                    if level > appState.soundLevelThreshold {
                        if (appState.lastDistractionTime == nil || Date() > (appState.lastDistractionTime?
                                    .addingTimeInterval(5))!
                            )
                        {
                            appState.activeDistraction = .sound
                            appState.isShowingDistractionAlert = true
                        }
                    }
                }
                appState.soundLevelDetector.startMonitoring()
                print("Sound detection started")
            }
        }
        .onDisappear {
            // Head movement detector
            visionProPose.stopARKitSession()
            print("Head movement stopped")

            // Sound detector
            appState.soundLevelDetector.stopMonitoring()
            print("Sound detection stopped")
        }
    }
}
