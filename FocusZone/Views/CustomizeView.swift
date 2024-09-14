//
//  CustomizeView.swift
//  FocusZone
//
//  Created by Eason on 9/14/24.
//

import SwiftUI

let focusTimeLengthOptions = [
    1,
    5,
    10,
    20,
    30,
    40,
    50,
    60,
]

struct CustomizeView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismissWindow) private var dismissWindow
    
    var body: some View {
        @Bindable var appState = appState

        VStack(spacing: 20) {
            HStack {
                Button(action: {
                    dismissWindow(id: appState.customizeViewID)
                }) {
                    Image(systemName: "chevron.left")
                }
                .buttonBorderShape(.circle)
                
                Spacer()
                Text("Customize").font(.title)
                Spacer()
            }
            
            Picker("Focus Time Length",
                   selection: $appState.selectedFocusTimeLength) {
                ForEach(focusTimeLengthOptions, id: \.self) { timeLength in
                    Text("\(timeLength) miuntes")
                }
            }
                   .pickerStyle(WheelPickerStyle())
            
            ToggleImmersiveSpaceButton(text: "Start focus")
            
            Toggle(isOn: $appState.detectHeadMovement) {
                Text("Head Movement Detection")
            }
        }
        .padding()
    }
}

#Preview(windowStyle: .automatic, traits: .sizeThatFitsLayout) {
    CustomizeView()
        .environment(AppState())
}

