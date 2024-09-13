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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
                .environment(immersiveEnvironment)
        }

        ImmersiveSpace(id: appModel.immersiveSpaceID) {
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
        }
        // Set the immersion style to progressive, so the user can use the Digital Crown to dial in their experience.
        .immersionStyle(selection: .constant(.progressive), in: .progressive)
     }
}

/// A global log of events for the app.
let logger = Logger()
