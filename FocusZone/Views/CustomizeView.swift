//
//  CustomizeView.swift
//  FocusZone
//
//  Created by Eason on 9/14/24.
//

import SwiftUI

// sec
let focusTimeLengthOptions = [
    10, // 10 sec
    900, // 15min
    1800, // 30 min
    3600, // 60 min
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

            VStack(alignment: .leading) {
                Text("Focus duration")
                    .font(.subheadline)

                Picker("Focus Time Length",
                       selection: $appState.selectedFocusTimeLength) {
                    ForEach(focusTimeLengthOptions, id: \.self) { timeLength in
                        Text("\(timeLength / 60) mins")
                    }
                }
                       .pickerStyle(.segmented)
            }

            Divider()
            
            VStack(alignment: .leading) {
                Text("Choose background")
                    .font(.subheadline)
                
                HStack(spacing: 24) {
                    Button(action: {
                        appState.selectedImmersiveSpaceId = .space
                    }) {
                        VStack {
                            Image("Space")
                                .resizable()
                                .scaledToFill()
                                .clipShape(
                                    RoundedRectangle(cornerRadius: CGFloat(16))
                                )
                                .frame(width: 100, height: 100)
                            
                            Text("Space")
                        }
                        .padding(8)
                    }
                    .buttonStyle(.plain)
                    .buttonBorderShape(.roundedRectangle(radius: 16))
                    
                    Button(action: {
                        appState.selectedImmersiveSpaceId = .transparent
                    }) {
                        VStack {
                            Image(systemName: "circle.slash")
                                .frame(width: 100, height: 100)
                            Text("Transparent")
                        }
                        .padding(8)
                        .backgroundStyle(.primary)
                    }
                    .buttonStyle(.plain)
                    .buttonBorderShape(.roundedRectangle(radius: 16))
                }
            }

            Divider()

            VStack(alignment: .leading) {
                Text("Detect distraction")
                    .font(.subheadline)
                
                Form {
                    Toggle(isOn: $appState.detectHeadMovement) {
                        Text("Head movement")
                        Text("Receive warning when moving your head")
                    }
                    Toggle(isOn: $appState.detectPhone) {
                        Text("Phone detection")
                        Text("Receive warning when touching your phone")
                    }
                    Toggle(isOn: $appState.detectSound) {
                        Text("Sound detection")
                        Text("Receive warning when speaking")
                    }
                }
            }
            

            ToggleImmersiveSpaceButton(text: "Start focus")
                .environment(appState)
        }
        .padding()
    }
}

#Preview(windowStyle: .automatic, traits: .sizeThatFitsLayout) {
    CustomizeView()
        .environment(AppState())
}
