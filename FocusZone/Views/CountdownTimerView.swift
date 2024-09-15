//
//  CountdownTimerView.swift
//  FocusZone
//
//  Created by Eason on 9/14/24.
//

import SwiftUI

struct CountdownTimerView: View {
    @StateObject private var viewModel: CountdownTimerViewModel
    
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
                    viewModel.terminateCountdown()
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
    }
}

#Preview(windowStyle: .automatic, traits: .sizeThatFitsLayout) {
    let appState = AppState()
    
    CountdownTimerView(appState: appState)
        .onAppear() {
            appState.countdownTimer.startCountdown(numSecs: 10 * 60)
        }
        .persistentSystemOverlays(.hidden)
}
