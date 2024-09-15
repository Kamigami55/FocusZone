//
//  FocusZoneApp.swift
//  FocusZone
//
//  Created by Eason on 9/12/24.
//

import SwiftUI
import os

enum LongPressState {
    case inactive
    case pressing
    case released
}

@main
struct FocusZoneApp: App {

    @State private var appState = AppState()
    
    /// An object that stores the app's level of immersion.
    @State private var immersiveEnvironment = ImmersiveEnvironment()
    
    @Environment(\.scenePhase) private var scenePhase

    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow

    @GestureState private var longPressState: LongPressState = .inactive
    var longPress: some Gesture {
        LongPressGesture(minimumDuration: 0.5)
            .targetedToAnyEntity()
            .updating($longPressState) { value, gestureState, transaction in
                print("Updating")
                gestureState = .pressing
            }
            .onEnded { value in
                print(longPressState)
                switch longPressState {
                case .inactive:
                    print("Inactive stage")
                case .pressing:
                    print("Pressing stage")
                case .released:
                    print("Released stage")
                    if (!appState.isShowingCountdownView) {
                        openWindow(id: appState.countdownViewID)
                    }
                }
            }
    }
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
                .task {
                    if appState.allRequiredProvidersAreSupported {
                        await appState.referenceObjectLoader.loadBuiltInReferenceObjects()
                    }
                }
                .onChange(of: scenePhase, initial: true) {
                    print("HomeView scene phase: \(scenePhase)")
                    if scenePhase == .active {
                        Task {
                            // When returning from the background, check if the authorization has changed.
                            await appState.queryWorldSensingAuthorization()
                        }
                    } else {
                        // Make sure to leave the immersive space if this view is no longer active
                        // - such as when a person closes this view - otherwise they may be stuck
                        // in the immersive space without the controls this view provides.
                        if appState.immersiveSpaceState == .open {
                            Task {
//                                await dismissImmersiveSpace()
                                appState.didLeaveImmersiveSpace()
                            }
                        }
                    }
                }
        }
        .windowResizability(.contentSize)
        .defaultSize(width: 0, height: 0)  // Initial size, will be overridden by content
        
        WindowGroup(id: appState.countdownViewID) {
            CountdownTimerView(appState: appState)
                .environment(appState)
                .onAppear {
                    appState.isShowingCountdownView = true
                    // Disable resizing
                    guard let windowScene = UIApplication.shared.connectedScenes.second as?UIWindowScene else { return }
                    windowScene.requestGeometryUpdate(.Vision(resizingRestrictions: UIWindowScene.ResizingRestrictions.none))
                }
                .onDisappear {
                    appState.isShowingCountdownView = false
                }
        }
        .windowResizability(.contentSize)
        .defaultSize(width: 0, height: 0)  // Initial size, will be overridden by content

        ImmersiveSpace(id: appState.immersiveSpaceViewID) {
            PostDetectView()
                .environment(appState)
                .onAppear {
                    appState.immersiveSpaceState = .open
                    if (appState.countdownTimer.isRunning) {
                        appState.countdownTimer
                            .resumeCountdown()
                    } else {
                        appState.countdownTimer.startCountdown(numSecs: appState.selectedFocusTimeLength)
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
                .task {
                    // Ask for authorization before a person attempts to open the immersive space.
                    // This gives the app opportunity to respond gracefully if authorization isn't granted.
                    if appState.allRequiredProvidersAreSupported {
                        await appState.requestWorldSensingAuthorization()
                    }
                }
                .task {
                    // Start monitoring for changes in authorization, in case a person brings the
                    // Settings app to the foreground and changes authorizations there.
                    await appState.monitorSessionEvents()
                }
            
            if (appState.selectedImmersiveSpaceId == .space) {
                SolarSystem()
                    .environment(appState)
            }
        }
        .immersionStyle(selection: .constant(.progressive), in: .progressive)
        .immersiveContentBrightness(
            appState.selectedImmersiveSpaceId == .transparent ? .dim : .automatic
        )
     }
}

/// A global log of events for the app.
let logger = Logger()
