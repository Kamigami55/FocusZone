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
    
    @Published var isFinished: Bool = false

    private var timer: Timer?

    var hasCountdownCompleted: Bool {
        Date() >= endDate
    }

    init() {}
    
    func startCountdown(numSecs: Int) {
        print("Starting countdown for \(numSecs) seconds") // Debug print
        endDate = Date().addingTimeInterval(TimeInterval(numSecs))
        isRunning = true
        pausedTimeRemaining = nil
        startTimer()
        updateTimer()
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
        isFinished = false
    }
    
    func pauseCountdown() {
        guard isRunning else { return }
        isRunning = false
        pausedTimeRemaining = endDate.timeIntervalSince(Date())
        timer?.invalidate()
    }
    
    func resumeCountdown() {
        guard !isRunning, let remaining = pausedTimeRemaining else { return }
        startDate = Date()
        endDate = startDate!.addingTimeInterval(remaining)
        isRunning = true
        isFinished = false
        pausedTimeRemaining = nil
        startTimer()
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
        timer?.invalidate()
    }
    
    func updateTimer() {
        guard isRunning else { return }
        
        let now = Date()
//        print("Updating timer. Current time: \(now), End time: \(endDate)") // Debug print
        
        if now < endDate {
            let components = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: now, to: endDate)
            
            day = components.day ?? 0
            hour = components.hour ?? 0
            minute = components.minute ?? 0
            second = components.second ?? 0
//            print("Updated time: \(minute)m \(second)s") // Debug print
        } else {
            print("Countdown completed") // Debug print
            terminateCountdown()
            isFinished = true
        }
    }
}
