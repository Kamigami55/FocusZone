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
    @Environment(AppModel.self) private var appModel

    
    var body: some View {
        @Bindable var appModel = appModel
        
        Text("Customize").font(.title)
        
        Picker("Focus Time Length",
               selection: $appModel.selectedFocusTimeLength) {
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
}

#Preview(windowStyle: .automatic) {
    CustomizeView()
        .frame(width: 500, height: 300)
        .environment(AppModel())
}
