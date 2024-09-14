/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A toggle that activates or deactivates the solar system scene.
*/

import SwiftUI

/// A toggle that activates or deactivates the solar system scene.
struct SolarSystemToggle: View {
    @Environment(AppState.self) private var appState
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace

    var body: some View {
        Button {
            Task {
                if appState.isShowingSolar {
                    await dismissImmersiveSpace()
                } else {
                    await openImmersiveSpace(id: appState.solarSystemID)
                }
            }
        } label: {
            if appState.isShowingSolar {
                Label(
                    "Exit the Solar System",
                    systemImage: "arrow.down.right.and.arrow.up.left")
            } else {
                Text(String(localized: "View Outer Space", comment: "An action the viewer can take in the Solar System module."))
            }
        }
    }
}

#Preview {
    SolarSystemToggle()
        .environment(AppState())
}
