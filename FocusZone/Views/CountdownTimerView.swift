//
//  CountdownTimerView.swift
//  FocusZone
//
//  Created by Eason on 9/14/24.
//

import SwiftUI

struct CountdownTimerView: View {
    @StateObject var viewModel = CountdownTimerViewModel()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private var hasCountdownCompleted: Bool {
        viewModel.hasCountdownCompleted
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(spacing: 8) {
                    Text(String(format: "%02d", viewModel.day))
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
                    Text(String(format: "%02d", viewModel.hour))
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
                    Text(String(format: "%02d", viewModel.minute))
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
                    Text(String(format: "%02d", viewModel.second))
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.red)
                    Text("sec")
                        .textCase(.uppercase)
                        .font(.system(size: 11))
                }
            }
            
            Button("Start 25 min countdown") {
                viewModel.startCountdown(numSecs: 25 * 60)
            }
            .disabled(viewModel.isRunning)
            
            if viewModel.isRunning {
                Button("Pause") {
                    viewModel.pauseCountdown()
                }
            } else if viewModel.pausedTimeRemaining != nil {
                Button("Resume") {
                    viewModel.resumeCountdown()
                }
            }
            
            Button("Terminate") {
                viewModel.terminateCountdown()
            }
            .disabled(!viewModel.isRunning && viewModel.pausedTimeRemaining == nil)
        }
        .onReceive(timer) { _ in
            viewModel.updateTimer()
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
}
