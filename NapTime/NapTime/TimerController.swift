//
//  TimerController.swift
//  NapTime
//
//  Created by Eric Andersen on 8/28/18.
//  Copyright © 2018 Eric Andersen. All rights reserved.
//

import Foundation
import UserNotifications

protocol TimerControllerDelegate: class {
    
    var identifier: String { get }
    
    func timerSecondTick()
    func timerCompleted()
    func timerStopped()
}

extension TimerControllerDelegate {
    
    func scheduleLocalNotification() {
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Wake Up!"
        notificationContent.body = "No... Seriously Wake Up."
        
        guard let timeRemaining = TimerController.shared.timeRemaining else { return }
        
        let date = Date(timeInterval: timeRemaining, since: Date())
        let dateComponents = Calendar.current.dateComponents([.minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: notificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Unable to add Notification Request. \(error) \(error.localizedDescription)")
            }
        }
    }
    
    func cancelLocalNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}

class TimerController {
    
    var timeRemaining: TimeInterval?
    var timer: Timer?
    
    static let shared = TimerController()
    var delegate: TimerControllerDelegate?
    
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
        let seconds = timeRemaining - (minutes * 60)
        
        return String(format: "%02d : %02d", arguments: [minutes, seconds])
    }
    
    func secondTick() {
        guard let timeRemaining = timeRemaining else { return }
        if timeRemaining > 0 {
            self.timeRemaining = timeRemaining - 1
            print(timeRemaining)
            delegate?.timerSecondTick()
        } else {
            timer?.invalidate()
            self.timeRemaining = nil
            print("Stop Timer")
            delegate?.timerCompleted()
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
            delegate?.timerStopped()
        }
    }
}






























































