/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
Custom view modifiers that the app defines.
*/

import SwiftUI
import SwiftData

extension View {
    // A custom modifier in visionOS that manages the presentation and dismissal of the app's environment.
    func immersionManager() -> some View {
        self.modifier(ImmersiveSpacePresentationModifier())
    }
}

private struct ImmersiveSpacePresentationModifier: ViewModifier {
    @Environment(ImmersiveEnvironment.self) private var immersiveEnvironment
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace

    func body(content: Content) -> some View {
        content
            .onChange(of: immersiveEnvironment.showImmersiveSpace) { _, show in
                Task { @MainActor in
                    if !immersiveEnvironment.immersiveSpaceIsShown, show {
                        switch await openImmersiveSpace(id: ImmersiveEnvironmentView.id) {
                        case .opened:
                            immersiveEnvironment.immersiveSpaceIsShown = true
                        case .error, .userCancelled:
                            fallthrough
                        @unknown default:
                            immersiveEnvironment.immersiveSpaceIsShown = false
                            immersiveEnvironment.showImmersiveSpace = false
                        }
                    } else if immersiveEnvironment.immersiveSpaceIsShown {
                        await dismissImmersiveSpace()
                    }
                }
            }
    }
}
