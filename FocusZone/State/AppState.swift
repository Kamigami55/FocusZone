//
//  AppModel.swift
//  FocusZone
//
//  Created by Eason on 9/12/24.
//

import SwiftUI
import ARKit

enum ImmersiveSpaceId: String, CaseIterable {
    case transparent
    case space
}

enum ImmersiveSpaceState {
    case closed
    case inTransition
    case open
}

enum DistractionType {
    case headMovement
    case phone
    case sound
}

/// Maintains app-wide state
@MainActor
@Observable
class AppState {
    let homeViewID = "HomeView"
    let countdownViewID = "CountdownView"
    let immersiveSpaceViewID = "ImmersiveSpaceView"

    var isShowingCustomizeView: Bool = false
    var isShowingCountdownView: Bool = false

    var lastDistractionTime: Date? = nil
    var activeDistraction: DistractionType? = nil
    var isShowingDistractionAlert: Bool = false

    var isShowingConfirmStopAlert: Bool = false
    var isShowingFinishAlert: Bool = false

    var immersiveSpaceState = ImmersiveSpaceState.closed
    
    var selectedFocusTimeLength: Int = 30 * 60
    var selectedImmersiveSpaceId: ImmersiveSpaceId = .space
    
    var detectHeadMovement: Bool = true
    var detectPhone: Bool = true
    var detectSound: Bool = true

    let countdownTimer = CountdownTimerViewModel()

    var soundLevelThreshold: Float = -20.0

    let soundLevelDetector = SoundLevelDetector()
    
    // MARK: - Object detection stuff
    let referenceObjectLoader = ReferenceObjectLoader()
    
    func didLeaveImmersiveSpace() {
        // Stop the provider; the provider that just ran in the
        // immersive space is now in a paused state and isn't needed
        // anymore. When a person reenters the immersive space,
        // run a new provider.
        arkitSession.stop()
    }
    
    private let arkitSession = ARKitSession()
    
    private var objectTracking: ObjectTrackingProvider? = nil
    
    var objectTrackingStartedRunning = false
    
    var providersStoppedWithError = false
    
    var worldSensingAuthorizationStatus = ARKitSession.AuthorizationStatus.notDetermined
    
    func startTracking() async -> ObjectTrackingProvider? {
        let referenceObjects = referenceObjectLoader.enabledReferenceObjects
        
        guard !referenceObjects.isEmpty else {
//            fatalError("No reference objects to start tracking")
            print("No reference objects to start tracking")
            return nil
        }
        
        // Run a new provider every time when entering the immersive space.
        let objectTracking = ObjectTrackingProvider(referenceObjects: referenceObjects)
        do {
            try await arkitSession.run([objectTracking])
        } catch {
            print("Error: \(error)" )
            return nil
        }
        self.objectTracking = objectTracking
        return objectTracking
    }
    
    var allRequiredAuthorizationsAreGranted: Bool {
        worldSensingAuthorizationStatus == .allowed
    }
    
    var allRequiredProvidersAreSupported: Bool {
        ObjectTrackingProvider.isSupported
    }
    
    var canEnterImmersiveSpace: Bool {
        allRequiredAuthorizationsAreGranted && allRequiredProvidersAreSupported
    }
    
    func requestWorldSensingAuthorization() async {
        let authorizationResult = await arkitSession.requestAuthorization(for: [.worldSensing])
        worldSensingAuthorizationStatus = authorizationResult[.worldSensing]!
    }
    
    func queryWorldSensingAuthorization() async {
        let authorizationResult = await arkitSession.queryAuthorization(for: [.worldSensing])
        worldSensingAuthorizationStatus = authorizationResult[.worldSensing]!
    }
    
    func monitorSessionEvents() async {
        for await event in arkitSession.events {
            switch event {
            case .dataProviderStateChanged(let providers, let newState, let error):
                switch newState {
                case .initialized:
                    break
                case .running:
                    guard objectTrackingStartedRunning == false, let objectTracking else { continue }
                    for provider in providers where provider === objectTracking {
                        objectTrackingStartedRunning = true
                        break
                    }
                case .paused:
                    break
                case .stopped:
                    guard objectTrackingStartedRunning == true, let objectTracking else { continue }
                    for provider in providers where provider === objectTracking {
                        objectTrackingStartedRunning = false
                        break
                    }
                    if let error {
                        print("An error occurred: \(error)")
                        providersStoppedWithError = true
                    }
                @unknown default:
                    break
                }
            case .authorizationChanged(let type, let status):
                print("Authorization type \(type) changed to \(status)")
                if type == .worldSensing {
                    worldSensingAuthorizationStatus = status
                }
            default:
                print("An unknown event occurred \(event)")
            }
        }
    }
}
