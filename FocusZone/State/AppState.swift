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
    let splineImmersiveSpaceID = "SplineImmersiveSpace"
    let solarSystemID = "SolarSystem"
    let customizeViewID = "CustomizeView"
    enum ImmersiveSpaceState {
        case closed
        case inTransition
        case open
    }
    var immersiveSpaceState = ImmersiveSpaceState.closed
    var isShowingSolar = false
    
    var selectedFocusTimeLength: Int = 30
}
