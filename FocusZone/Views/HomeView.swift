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
            Image("AppIcon-standalone")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .shadow(radius: 10)

            Text("Focus Zone").font(.title)
            Text("Get things done")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 10) {
                Button(action: {
                    appState.isShowingCustomizeView = true
                }) {
                    HStack {
                        Text("\(appState.selectedFocusTimeLength / 60) mins")
                        Image(systemName: "chevron.right")
                    }
                    .frame(maxWidth: .infinity)
                }

                ToggleImmersiveSpaceButton(text: "Start")
            }
        }.padding()
    }
}

#Preview(windowStyle: .automatic) {
    HomeView()
        .frame(width: 500, height: 300)
        .environment(AppState())
}
