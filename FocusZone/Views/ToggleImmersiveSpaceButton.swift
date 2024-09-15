//
//  ToggleImmersiveSpaceButton.swift
//  FocusZone
//
//  Created by Eason on 9/12/24.
//

import SwiftUI

struct ToggleImmersiveSpaceButton: View {
    var text: String

    @Environment(AppState.self) private var appState

    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace

    var body: some View {
        Button {
            Task { @MainActor in
                switch appState.immersiveSpaceState {
                    case .open:
                        appState.immersiveSpaceState = .inTransition
                        await dismissImmersiveSpace()
                        // Don't set immersiveSpaceState to .closed because there
                        // are multiple paths to ImmersiveView.onDisappear().
                        // Only set .closed in ImmersiveView.onDisappear().

                    case .closed:
                        appState.immersiveSpaceState = .inTransition
                        switch await openImmersiveSpace(
                            id: appState.immersiveSpaceViewID
                        ) {
                            case .opened:
                                // Don't set immersiveSpaceState to .open because there
                                // may be multiple paths to ImmersiveView.onAppear().
                                // Only set .open in ImmersiveView.onAppear().
                                break

                            case .userCancelled, .error:
                                // On error, we need to mark the immersive space
                                // as closed because it failed to open.
                                fallthrough
                            @unknown default:
                                // On unknown response, assume space did not open.
                                appState.immersiveSpaceState = .closed
                        }

                    case .inTransition:
                        // This case should not ever happen because button is disabled for this case.
                        break
                }
            }
        } label: {
            Text(text)
                .frame(maxWidth: .infinity)
        }
        .disabled(appState.immersiveSpaceState == .inTransition)
        .animation(.none, value: 0)
    }
}

#Preview {
    ToggleImmersiveSpaceButton(text: "Button")
        .environment(AppState())
}
