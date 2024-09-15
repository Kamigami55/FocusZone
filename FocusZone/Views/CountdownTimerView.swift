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

    init(appState: AppState) {
        self._viewModel = StateObject(wrappedValue: appState.countdownTimer)
    }
    
    var body: some View {
        @Bindable var appState = appState

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
                    appState.isShowingConfirmStopAlert = true
                }) {
                    Image(systemName: "stop.fill")
                }
                .buttonBorderShape(.circle)
                .disabled(!viewModel.isRunning && viewModel.pausedTimeRemaining == nil)
                
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
        .onChange(of: appState.countdownTimer.isFinished) { _, isFinished in
            if isFinished {
                appState.isShowingFinishAlert = true
                viewModel.isFinished = false  // Reset the flag
            }
        }
        .alert(Text("Confirm leaving"), isPresented: $appState.isShowingConfirmStopAlert, actions: {
            Button("Leave", role: .destructive) {
                Task {
                    viewModel.terminateCountdown()
                    appState.isShowingConfirmStopAlert = false
                    dismissWindow(id: appState.countdownViewID)
                    await dismissImmersiveSpace()
                }
            }
            Button("Continue", role: .cancel) {
                appState.isShowingConfirmStopAlert = false
            }
        }, message: {
            Text("If you leave, the timer will restart next time.")
        })
        .alert(Text("Congratulations!"), isPresented: $appState.isShowingFinishAlert, actions: {
            Button("Start another focus") {
                Task {
                    appState.isShowingFinishAlert = false
                    appState.countdownTimer.startCountdown(numSecs: appState.selectedFocusTimeLength)
                }
            }
            .disabled(appState.immersiveSpaceState == .inTransition)
            Button("Done", role: .cancel) {
                Task {
                    appState.isShowingFinishAlert = false
                    appState.countdownTimer.terminateCountdown()
                    dismissWindow(id: appState.countdownViewID)
                    appState.immersiveSpaceState = .inTransition
                    await dismissImmersiveSpace()
                }
            }
            .disabled(appState.immersiveSpaceState == .inTransition)
        }, message: {
            Text("You finished a \(appState.selectedFocusTimeLength / 60) minitus focus time.")
        })
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
