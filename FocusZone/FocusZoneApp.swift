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

    @State private var appState = AppState()
    
    /// An object that stores the app's level of immersion.
    @State private var immersiveEnvironment = ImmersiveEnvironment()

    var body: some Scene {
        @Bindable var appState = appState

        WindowGroup(id: appState.homeViewID) {
            HomeView()
                .environment(appState)
                .onAppear {
                    // Disable resizing
                    guard let windowScene = UIApplication.shared.connectedScenes.first as?UIWindowScene else { return }
                    windowScene.requestGeometryUpdate(.Vision(resizingRestrictions: UIWindowScene.ResizingRestrictions.none))
                }
                .preferredSurroundingsEffect(.systemDark)
                .sheet(isPresented: $appState.isShowingCustomizeView) {
                    CustomizeView()
                        .environment(appState)
                }
        }
        .windowResizability(.contentSize)
        .defaultSize(width: 0, height: 0)  // Initial size, will be overridden by content

        ImmersiveSpace(id: ImmersiveSpaceId.transparent.rawValue) {
            PostDetectView()
                .onAppear {
                    appState.immersiveSpaceState = .open
                }
                .onDisappear {
                    appState.immersiveSpaceState = .closed
                }
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
        
        ImmersiveSpace(id: ImmersiveSpaceId.space.rawValue) {
            PostDetectView()
                .onAppear {
                    appState.immersiveSpaceState = .open
                }
                .onDisappear {
                    appState.immersiveSpaceState = .closed
                }

            SolarSystem()
                .environment(appState)
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
     }
}

/// A global log of events for the app.
let logger = Logger()
