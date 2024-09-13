/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The model content for the solar system module.
*/

import SwiftUI
import RealityKit

/// The model content for the solar system module.
struct SolarSystem: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        ZStack {
            Starfield()
        }
        .onAppear {
            model.isShowingSolar = true
        }
        .onDisappear {
            model.isShowingSolar = false
        }
    }
}
