//
//  FocusZoneApp.swift
//  FocusZone
//
//  Created by Eason on 9/12/24.
//

import SwiftUI
import os

@main
struct FocusZoneApp: App {

    @State private var appModel = AppModel()
    
    /// An object that stores the app's level of immersion.
    @State private var immersiveEnvironment = ImmersiveEnvironment()
    /// The content brightness to apply to the immersive space.
    @State private var contentBrightness: ImmersiveContentBrightness = .automatic
    /// The effect modifies the passthrough in immersive space.
    @State private var surroundingsEffect: SurroundingsEffect? = nil

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
                .environment(immersiveEnvironment)
        }

        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            PostDetectView()

            ImmersiveView()
                .environment(appModel)
                .onAppear {
                    appModel.immersiveSpaceState = .open
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                }
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
        
        // An immersive Space that shows the Earth, Moon, and Sun as seen from
        // Earth orbit.
        ImmersiveSpace(id: appModel.solarSystemID) {
            SolarSystem()
                .environment(appModel)
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
        
        // Defines an immersive space to present a destination in which to watch the video.
        ImmersiveSpace(id: ImmersiveEnvironmentView.id) {
            ImmersiveEnvironmentView()
                .environment(immersiveEnvironment)
                .onAppear {
                    contentBrightness = immersiveEnvironment.contentBrightness
                    surroundingsEffect = immersiveEnvironment.surroundingsEffect
                }
                .onDisappear {
                    contentBrightness = .automatic
                    surroundingsEffect = nil
                }
            // Apply a custom tint color for the video passthrough of a person's hands and surroundings.
                .preferredSurroundingsEffect(surroundingsEffect)
        }
        // Set the content brightness for the immersive space.
        .immersiveContentBrightness(contentBrightness)
        // Set the immersion style to progressive, so the user can use the Digital Crown to dial in their experience.
        .immersionStyle(selection: .constant(.progressive), in: .progressive)
     }
}

/// A global log of events for the app.
let logger = Logger()
