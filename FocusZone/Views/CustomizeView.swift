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

    
    var body: some View {
        @Bindable var appState = appState
        
        VStack(spacing: 20) {
            Text("Customize").font(.title)
            
            Picker("Focus Time Length",
                   selection: $appState.selectedFocusTimeLength) {
                ForEach(focusTimeLengthOptions, id: \.self) { timeLength in
                    Text("\(timeLength) miuntes")
                }
            }.pickerStyle(WheelPickerStyle()
            )
            
            Button(action: {
                print("Start Button Pressed")
            }) {
                Text("Start focus")
            }
        }
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    CustomizeView()
        .frame(width: 500, height: 300)
        .environment(AppState())
}
