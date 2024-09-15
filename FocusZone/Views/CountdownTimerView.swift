//
//  CountdownTimerView.swift
//  FocusZone
//
//  Created by Eason on 9/14/24.
//

import SwiftUI

struct CountdownTimerView: View {
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace

    @Environment(AppState.self) private var appState
    @StateObject private var viewModel: CountdownTimerViewModel
    @State private var isShowingAlert: Bool = false

    init(appState: AppState) {
        self._viewModel = StateObject(wrappedValue: appState.countdownTimer)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text(String(format: "%02d", viewModel.minute))
                    .font(.system(size: 40, weight: .bold))
                Text(":")
                    .font(.system(size: 40, weight: .bold))
                Text(String(format: "%02d", viewModel.second))
                    .font(.system(size: 40, weight: .bold))
            }
            
            HStack (spacing: 16) {
                Button(action: {
                    isShowingAlert = true
                }) {
                    Image(systemName: "stop.fill")
                }
                .buttonBorderShape(.circle)
                .disabled(!viewModel.isRunning && viewModel.pausedTimeRemaining == nil)
                .alert(Text("Confirm leaving"), isPresented: $isShowingAlert, actions: {
                    Button("Leave") {
                        Task {
                            viewModel.terminateCountdown()
                            await dismissImmersiveSpace()
                            dismissWindow(id: appState.countdownViewID)
                            openWindow(id: appState.homeViewID)
                        }
                    }
                    Button("Continue", role: .cancel) {
                        isShowingAlert = false
                    }
                }, message: {
                    Text("If you leave, the timer will restart next time.")
                })
                
                if viewModel.isRunning {
                    Button(action: {
                        viewModel.pauseCountdown()
                    }) {
                        Image(systemName: "pause.fill")
                    }
                    .buttonBorderShape(.circle)
                } else if viewModel.pausedTimeRemaining != nil {
                    Button(action: {
                        viewModel.resumeCountdown()
                    }) {
                        Image(systemName: "play.fill").padding(20)
                    }
                    .buttonBorderShape(.circle)
                }
            }
        }
    }
}

#Preview(windowStyle: .automatic, traits: .sizeThatFitsLayout) {
    let appState = AppState()
    
    CountdownTimerView(appState: appState)
        .environment(appState)
        .onAppear() {
            appState.countdownTimer.startCountdown(numSecs: 10 * 60)
        }
}
