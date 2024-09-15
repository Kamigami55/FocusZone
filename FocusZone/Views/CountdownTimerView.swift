//
//  CountdownTimerView.swift
//  FocusZone
//
//  Created by Eason on 9/14/24.
//

import SwiftUI

struct CountdownTimerView: View {
    @Environment(AppState.self) private var appState
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private var hasCountdownCompleted: Bool {
        appState.countdownTimer.hasCountdownCompleted
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(spacing: 8) {
                    Text(String(format: "%02d", appState.countdownTimer.day))
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.red)
                    Text("day")
                        .textCase(.uppercase)
                        .font(.system(size: 11))
                }
                VStack(spacing: 8) {
                    colon
                    Spacer()
                        .frame(height: 15)
                }
                VStack(spacing: 8) {
                    Text(String(format: "%02d", appState.countdownTimer.hour))
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.red)
                    Text("hour")
                        .textCase(.uppercase)
                        .font(.system(size: 11))
                }
                VStack(spacing: 8) {
                    colon
                    Spacer()
                        .frame(height: 15)
                }
                VStack(spacing: 8) {
                    Text(String(format: "%02d", appState.countdownTimer.minute))
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.red)
                    Text("min")
                        .textCase(.uppercase)
                        .font(.system(size: 11))
                }
                VStack(spacing: 8) {
                    colon
                    Spacer()
                        .frame(height: 15)
                }
                VStack(spacing: 8) {
                    Text(String(format: "%02d", appState.countdownTimer.second))
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.red)
                    Text("sec")
                        .textCase(.uppercase)
                        .font(.system(size: 11))
                }
            }
            
            Button("Start \(appState.selectedFocusTimeLength) min countdown") {
                appState.countdownTimer.startCountdown(numSecs: appState.selectedFocusTimeLength * 60)
            }
            .disabled(appState.countdownTimer.isRunning)
            
            if appState.countdownTimer.isRunning {
                Button("Pause") {
                    appState.countdownTimer.pauseCountdown()
                }
            } else if appState.countdownTimer.pausedTimeRemaining != nil {
                Button("Resume") {
                    appState.countdownTimer.resumeCountdown()
                }
            }
            
            Button("Terminate") {
                appState.countdownTimer.terminateCountdown()
            }
            .disabled(!appState.countdownTimer.isRunning && appState.countdownTimer.pausedTimeRemaining == nil)
        }
        .onReceive(timer) { _ in
            appState.countdownTimer.updateTimer()
        }
    }
}

extension CountdownTimerView {
    private var colon: some View {
        Text(":")
            .font(.system(size: 22, weight: .bold))
            .foregroundColor(.red)
    }
}

#Preview {
    CountdownTimerView()
        .environment(AppState())
}
