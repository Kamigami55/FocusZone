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
    @Published var day: Int = 0
    @Published var hour: Int = 0
    @Published var minute: Int = 0
    @Published var second: Int = 0
    
    private var startDate: Date?
    private var endDate: Date = Date()

    @Published var isRunning: Bool = false
    @Published var pausedTimeRemaining: TimeInterval?

    var hasCountdownCompleted: Bool {
        Date() > endDate
    }

    init() {}
    
    func startCountdown(numSecs: Int) {
        print("Starting countdown for \(numSecs) seconds") // Debug print
        startDate = Date()
        endDate = startDate!.addingTimeInterval(TimeInterval(numSecs))
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
        day = 0
        hour = 0
        minute = 0
        second = 0
    }
    
    func updateTimer() {
        guard isRunning else { return }
        
        let now = Date()
        print("Updating timer. Current time: \(now), End time: \(endDate)") // Debug print
        
        let calendar = Calendar(identifier: .gregorian)
        let timeValue = calendar.dateComponents(
            [.day, .hour, .minute, .second],
            from: now,
            to: endDate
        )
        
        if now < endDate,
           let day = timeValue.day,
           let hour = timeValue.hour,
           let minute = timeValue.minute,
           let second = timeValue.second {
            self.day = day
            self.hour = hour
            self.minute = minute
            self.second = second
            print("Updated time: \(day)d \(hour)h \(minute)m \(second)s") // Debug print
        } else {
            print("Countdown completed or invalid") // Debug print
            terminateCountdown()
        }
    }
}