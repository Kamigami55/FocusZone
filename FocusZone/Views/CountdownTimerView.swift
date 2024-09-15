//
//  CountdownTimerView.swift
//  FocusZone
//
//  Created by Eason on 9/14/24.
//

import SwiftUI

struct CountdownTimerView: View {
    @StateObject var viewModel: CountdownTimerViewModel
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private var hasCountdownCompleted: Bool {
        viewModel.hasCountdownCompleted
    }
    
    init(endDate: String) {
        _viewModel = StateObject(wrappedValue: CountdownTimerViewModel(endDate: endDate))
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
        }
        .onReceive(timer) { _ in
            if hasCountdownCompleted {
                timer.upstream.connect().cancel() // turn off timer
            } else {
                viewModel.updateTimer()
            }
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
    CountdownTimerView(endDate: Date.distantFuture.ISO8601Format())
}
