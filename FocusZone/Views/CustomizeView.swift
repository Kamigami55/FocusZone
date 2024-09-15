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

        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Button(action: {
                    appState.isShowingCustomizeView = false
                }) {
                    Image(systemName: "chevron.left")
                }
                .buttonBorderShape(.circle)
                
                Spacer()
                Text("Customize focus experience").font(.title)
                Spacer()
                VStack {}.frame(width: 32, height: 32)
            }

            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "clock")
                        .fontWeight(.light)
                    Text("Focus duration")
                        .fontWeight(.bold)
                        .font(.subheadline)
                }.padding(.bottom, 12)

                Picker("Focus Time Length",
                       selection: $appState.selectedFocusTimeLength) {
                    ForEach(focusTimeLengthOptions, id: \.self) { timeLength in
                        Text(timeLength >= 60 ? "\(timeLength / 60) mins" : "\(timeLength) secs")
                    }
                }
                       .pickerStyle(.segmented)
            }

            Divider()
            
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "mountain.2")
                        .font(.system(size: 10))
                    Text("Immersive environment")
                        .font(.subheadline)
                        .fontWeight(.bold)
                }
                
                HStack {
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
                    .padding(.vertical, -16)
                    .frame(width: 120, height: 160)
                    
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
                    .padding(.vertical, -16)
                    .frame(width: 120, height: 160)
                }
                .frame(width: .infinity)
            }.frame(width: .infinity)

            Divider()

            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "moon")
                        .font(.system(size: 14))
                    Text("Distraction detection")
                        .font(.subheadline)
                        .fontWeight(.bold)
                }.padding(.bottom, 12)

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
                .frame(height: 200)
                .padding(.horizontal, -20)
            }
            

            ToggleImmersiveSpaceButton(text: "Start focus")
                .environment(appState)
        }
        .padding(EdgeInsets(top: 32, leading: 24, bottom: 32, trailing: 24))
    }
}

#Preview(windowStyle: .automatic) {
    CustomizeView()
        .environment(AppState())
}
