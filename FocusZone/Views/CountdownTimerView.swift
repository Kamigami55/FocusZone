//
//  CountdownTimerView.swift
//  FocusZone
//
//  Created by Eason on 9/14/24.
//

import SwiftUI

struct CountdownTimerView: View {
    @Environment(AppState.self) private var appState
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text(String(format: "%02d", appState.countdownTimer.minute))
                    .font(.system(size: 22, weight: .bold))
                Text(":")
                    .font(.system(size: 22, weight: .bold))
                Text(String(format: "%02d", appState.countdownTimer.second))
                    .font(.system(size: 22, weight: .bold))
            }
            
            Button("Start \(appState.selectedFocusTimeLength) min countdown") {
                appState.countdownTimer.startCountdown(numSecs: appState.selectedFocusTimeLength * 60)
            }
            .disabled(appState.countdownTimer.isRunning)
            
            if appState.countdownTimer.isRunning {
                Button(action: {
                    appState.countdownTimer.pauseCountdown()
                }) {
                    Image(systemName: "pause.fill")
                }
                .buttonBorderShape(.circle)
            } else if appState.countdownTimer.pausedTimeRemaining != nil {
                Button(action: {
                    appState.countdownTimer.resumeCountdown()
                }) {
                    Image(systemName: "play.fill")
                }
                .buttonBorderShape(.circle)
            }
            
            Button(action: {
                appState.countdownTimer.terminateCountdown()
            }) {
                Image(systemName: "stop.fill")
            }
            .buttonBorderShape(.circle)
            .disabled(!appState.countdownTimer.isRunning && appState.countdownTimer.pausedTimeRemaining == nil)
        }
    }
}

#Preview {
    CountdownTimerView()
        .environment(AppState())
}
