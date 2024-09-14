//
//  CustomizeView.swift
//  FocusZone
//
//  Created by Eason on 9/14/24.
//

import SwiftUI

let focusTimeLengthOptions = [
    15,
    30,
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
                    appState.isShowingCustomizeView = false
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
                    Text("\(timeLength) miuntes").tag(timeLength)
                }
            }
                   .pickerStyle(.segmented)
            
            VStack(alignment: .leading) {
                Text("Focus duration")
                    .font(.subheadline)
                HStack {
                    Button(action: { appState.selectedFocusTimeLength = 15 }) {
                        DurationButton(label: "15 mins", isSelected: appState.selectedFocusTimeLength == 15)
                    }
                    Button(action: { appState.selectedFocusTimeLength = 30 }) {
                        DurationButton(label: "30 mins", isSelected: appState.selectedFocusTimeLength == 30)
                    }
                    Button(action: { appState.selectedFocusTimeLength = 60 }) {
                        DurationButton(label: "60 mins", isSelected: appState.selectedFocusTimeLength == 60)
                    }
                }
            }
            .padding()
            
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

struct DurationButton: View {
    var label: String
    var isSelected: Bool
    
    var body: some View {
        Text(label)
//            .padding()
//            .frame(width: 100)
//            .background(isSelected ? Color.gray : Color.clear)
//            .cornerRadius(10)
//            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
//            .foregroundColor(.black)
    }
}
