//
//  CountdownTimerViewModel.swift
//  FocusZone
//
//  Created by Eason on 9/14/24.
//
import SwiftUI
import os

@MainActor
class CountdownTimerViewModel: ObservableObject {
    // These will be used to store the current value of
    // the unit on the clock, which then notifies the view
    // of a change to display when the original value is updated
    @Published var minute: Int = 0
    @Published var second: Int = 0
    
    private var startDate: Date?
    private var endDate: Date = Date()

    @Published var isRunning: Bool = false
    @Published var pausedTimeRemaining: TimeInterval?

    var hasCountdownCompleted: Bool {
        Date() >= endDate
    }

    init() {}
    
    func startCountdown(numSecs: Int) {
        endDate = Date().addingTimeInterval(TimeInterval(numSecs))
        isRunning = true
        pausedTimeRemaining = nil
        updateTimer()
    }
    
    func pauseCountdown() {
        guard isRunning else { return }
        isRunning = false
        pausedTimeRemaining = endDate.timeIntervalSince(Date())
    }
    
    func resumeCountdown() {
        guard !isRunning, let remaining = pausedTimeRemaining else { return }
        startDate = Date()
        endDate = startDate!.addingTimeInterval(remaining)
        isRunning = true
        pausedTimeRemaining = nil
    }
    
    func terminateCountdown() {
        isRunning = false
        startDate = nil
        endDate = Date()
        pausedTimeRemaining = nil
        minute = 0
        second = 0
    }
    
    func updateTimer() {
        guard isRunning else { return }
        
        let now = Date()
        if now < endDate {
            let components = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: now, to: endDate)
            
            minute = components.minute ?? 0
            second = components.second ?? 0
        } else {
            terminateCountdown()
        }
    }
}
