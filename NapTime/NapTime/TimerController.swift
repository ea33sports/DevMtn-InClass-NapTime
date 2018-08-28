//
//  TimerController.swift
//  NapTime
//
//  Created by Eric Andersen on 8/28/18.
//  Copyright © 2018 Eric Andersen. All rights reserved.
//

import Foundation

class TimerController {
    
    var timeRemaining: TimeInterval?
    var timer: Timer?
    
    static let shared = TimerController()
    
    var isOn: Bool {
        if timeRemaining != nil {
            return true
        } else {
            return false
        }
    }
    
    
    func timeAsString() -> String {
        let timeRemaining = Int(self.timeRemaining ?? 20 * 60)
        let minutes = timeRemaining / 60
        let seconds = timeRemaining - (minutes / 60)
        
        return "\(minutes) : \(seconds)"
    }
    
    func secondTick() {
        guard let timeRemaining = timeRemaining else { return }
        if timeRemaining > 0 {
            self.timeRemaining = timeRemaining - 1
            print(timeRemaining)
        } else {
            timer?.invalidate()
            self.timeRemaining = nil
        }
    }
    
    func startTimer(time: TimeInterval) {
        if !isOn {
            timeRemaining = time
            DispatchQueue.main.async {
                self.secondTick()
                self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (_) in
                    self.secondTick()
                })
            }
        }
    }
    
    func stopTimer() {
        if isOn {
            timer?.invalidate()
            timeRemaining = nil
        }
    }
}






























































