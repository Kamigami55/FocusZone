//
//  HomeView.swift
//  FocusZone
//
//  Created by Eason on 9/14/24.
//

import SwiftUI

struct HomeView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        VStack(spacing: 20) {
            Group {
                Image("AppIcon-standalone")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .shadow(radius: 10)
            }
            .frame(width: 100, height: 100)

            Text("Welcome to Focus Zone").font(.title)
            Text("Your Productivity Assistant")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
            
            HStack(spacing: 10) {
                Button(action: {
                    appState.isShowingCustomizeView = true
                }) {
                    HStack {
                        Text(appState.selectedFocusTimeLength >= 60 ? "\(appState.selectedFocusTimeLength / 60) mins" : "\(appState.selectedFocusTimeLength) secs")
                        Image(systemName: "chevron.right")
                    }
                    .frame(maxWidth: .infinity)
                }

                ToggleImmersiveSpaceButton(text: "Start")
            }
        }
            .padding(EdgeInsets(top: 40, leading: 24, bottom: 48, trailing: 24))
    }
}

#Preview(windowStyle: .automatic) {
    HomeView()
        .frame(width: 500, height: 300)
        .environment(AppState())
}
