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
    
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow

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
        
        WindowGroup(id: appState.countdownViewID) {
            CountdownTimerView(appState: appState)
                .onAppear {
                    // Disable resizing
                    guard let windowScene = UIApplication.shared.connectedScenes.second as?UIWindowScene else { return }
                    windowScene.requestGeometryUpdate(.Vision(resizingRestrictions: UIWindowScene.ResizingRestrictions.none))
                }
        }
        .windowResizability(.contentSize)
        .persistentSystemOverlays(.hidden)
        .defaultSize(width: 0, height: 0)  // Initial size, will be overridden by content

        ImmersiveSpace(id: appState.immersiveSpaceViewID) {
            PostDetectView()
                .onAppear {
                    appState.immersiveSpaceState = .open
                    if (appState.countdownTimer.isRunning) {
                        appState.countdownTimer
                            .resumeCountdown()
                    } else {
                        appState.countdownTimer.startCountdown(numSecs: appState.selectedFocusTimeLength * 60)
                    }
                    dismissWindow(id: appState.homeViewID)
                    openWindow(id: appState.countdownViewID)
                }
                .onDisappear {
                    appState.immersiveSpaceState = .closed
                    appState.countdownTimer.pauseCountdown()
                    dismissWindow(id: appState.countdownViewID)
                    openWindow(id: appState.homeViewID)
                }
            
            if (appState.selectedImmersiveSpaceId == .space) {
                SolarSystem()
                    .environment(appState)
            }
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
        .immersiveContentBrightness(
            appState.selectedImmersiveSpaceId == .transparent ? .dim : .automatic
        )
     }
}

/// A global log of events for the app.
let logger = Logger()
