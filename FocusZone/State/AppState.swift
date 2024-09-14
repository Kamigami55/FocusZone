//
//  AppModel.swift
//  FocusZone
//
//  Created by Eason on 9/12/24.
//

import SwiftUI

/// Maintains app-wide state
@MainActor
@Observable
class AppState {
    let immersiveSpaceID = "ImmersiveSpace"
    let homeViewID = "HomeView"
    
    enum ImmersiveSpaceState {
        case closed
        case inTransition
        case open
    }
    var isShowingCustomizeView: Bool = false

    var immersiveSpaceState = ImmersiveSpaceState.closed
    var isShowingSolar = false
    
    var selectedFocusTimeLength: Int = 30
    
    var detectHeadMovement: Bool = true
    var detectPhone: Bool = true
    var detectSound: Bool = true
}
