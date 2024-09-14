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
            Text("Focus Zone").font(.title)
            Text("Get things done")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 10) {
                Button(action: {
                    openWindow(id: appState.customizeViewID)
                }) {
                    HStack {
                        Text("\(appState.selectedFocusTimeLength) mins")
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
