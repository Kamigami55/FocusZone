//
//  AppModel.swift
//  FocusZone
//
//  Created by Eason on 9/12/24.
//

import SwiftUI

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
}
