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
    
    var endDate: Date = Date()
    var hasCountdownCompleted: Bool {
        Date() > endDate
    }
    
    @Published var isRunning: Bool = false
    private var startDate: Date?
    private var pausedTimeRemaining: TimeInterval?
    
    init(endDate: String) {
        self.endDate =  parseDate(endDate)
        updateTimer()
    }
    
    func startCountdown(numSecs: Int) {
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
        
        let calendar = Calendar(identifier: .gregorian)
        let timeValue = calendar.dateComponents(
            [.day, .hour, .minute, .second],
            from: Date.now,
            to: endDate
        )
        
        if !hasCountdownCompleted,
           let day = timeValue.day,
           let hour = timeValue.hour,
           let minute = timeValue.minute,
           let second = timeValue.second {
            self.day = day
            self.hour = hour
            self.minute = minute
            self.second = second
        } else {
            terminateCountdown()
        }
    }
    
    // Parse date from given string, identifying what format it matches.
    private func parseDate(_ dateString: String) -> Date {
        
        // Normally, you use DateFormatter to format date from a given string (i.e. "MM/dd/yy, yyyy-MM-dd, dd/MM/yy, etc).
        // But since we are formatting using the ISO 8601 format("yyyy-MM-dd’T’HH:mm:ssZ"), we can use ISO8601DateFormatter()
        // to create the date since the format is built into the class.
        let dateFormatter = ISO8601DateFormatter()
        guard let date = dateFormatter.date(from: dateString) else {
            return Date()
        }
        
        return date
    }
}
