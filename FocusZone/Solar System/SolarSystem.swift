/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The model content for the solar system module.
*/

import SwiftUI
import RealityKit
import SplineRuntime

/// The model content for the solar system module.
struct SolarSystem: View {
    @Environment(AppModel.self) private var model

    let url = URL(string: "https://build.spline.design/S9l5nViK3LJjATgo4JmH/scene.splineswift")!

    var body: some View {
        ZStack {
            Starfield()

            SplineVolumetricContent(sceneFileURL: url)
        }
        .onAppear {
            model.isShowingSolar = true
        }
        .onDisappear {
            model.isShowingSolar = false
        }
    }
}
