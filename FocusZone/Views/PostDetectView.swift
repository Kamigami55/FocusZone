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
    
    var root = Entity()
    
    @State private var objectVisualizations: [UUID: ObjectAnchorVisualization] = [:]
    
    var body: some View {
        RealityView { content in
            content.add(root)

            // MARK: Head movement detection:
            // Run each time scene is drawn (90Hz)
            _ =  content.subscribe(to: SceneEvents.Update.self) { event in
                Task {
                    if let currentHeadRoll = await visionProPose.queryDeviceRoll() {
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
                        }
                    }
                }
            }
            
            // MARK: Phone detection:
            Task {
                let objectTracking = await appState.startTracking()
                guard let objectTracking else {
                    return
                }
                print("Phone tracking started")
                
                // Wait for object anchor updates and maintain a dictionary of visualizations
                // that are attached to those anchors.
                for await anchorUpdate in objectTracking.anchorUpdates {
                    let anchor = anchorUpdate.anchor
                    let id = anchor.id
                    
                    switch anchorUpdate.event {
                    case .added:
                        print("PHONE ADDED")
                        if (appState.lastDistractionTime == nil || Date() > (appState.lastDistractionTime?
                            .addingTimeInterval(5))!
                        )
                        {
                            appState.activeDistraction = .phone
                            appState.isShowingDistractionAlert = true
                        }

                        // Create a new visualization for the reference object that ARKit just detected.
                        // The app displays the USDZ file that the reference object was trained on as
                        // a wireframe on top of the real-world object, if the .referenceobject file contains
                        // that USDZ file. If the original USDZ isn't available, the app displays a bounding box instead.
                        let model = appState.referenceObjectLoader.usdzsPerReferenceObjectID[anchor.referenceObject.id]
                        let visualization = ObjectAnchorVisualization(for: anchor, withModel: model)
                        self.objectVisualizations[id] = visualization
                        root.addChild(visualization.entity)
                    case .updated:
//                        print("PHONE UPDATED")
                        objectVisualizations[id]?.update(with: anchor)
                    case .removed:
                        objectVisualizations[id]?.entity.removeFromParent()
                        objectVisualizations.removeValue(forKey: id)
                    }
                }
            }
        }.onAppear() {
            Task {
                if (appState.detectHeadMovement) {
                    // Head movement detector
                    await visionProPose.runARKitSession()
                    print("Head movement started")
                }
                
                if (appState.detectSound) {
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
                
                if (appState.detectPhone) {
                    // Phone detector
                    await appState.queryWorldSensingAuthorization()
                    print("Phone detection started")
                }
            }
        }
        .onDisappear {
            if (appState.detectHeadMovement) {
                // Head movement detector
                visionProPose.stopARKitSession()
                print("Head movement stopped")
            }

            if (appState.detectSound) {
                // Sound detector
                appState.soundLevelDetector.stopMonitoring()
                print("Sound detection stopped")
            }
            
            if (appState.detectPhone) {
                // Phone detector
                for (_, visualization) in objectVisualizations {
                    root.removeChild(visualization.entity)
                }
                objectVisualizations.removeAll()
                appState.didLeaveImmersiveSpace()
                print("Phone detector stopped")
            }
        }
//        .task {
//            // Ask for authorization before a person attempts to open the immersive space.
//            // This gives the app opportunity to respond gracefully if authorization isn't granted.
//            if appState.allRequiredProvidersAreSupported {
//                await appState.requestWorldSensingAuthorization()
//            }
//        }
//        .task {
//            // Start monitoring for changes in authorization, in case a person brings the
//            // Settings app to the foreground and changes authorizations there.
//            await appState.monitorSessionEvents()
//        }
    }
}
