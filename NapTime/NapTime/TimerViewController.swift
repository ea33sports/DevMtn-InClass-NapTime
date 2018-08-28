//
//  TimerViewController.swift
//  NapTime
//
//  Created by Eric Andersen on 8/28/18.
//  Copyright © 2018 Eric Andersen. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController, TimerControllerDelegate {
    
    var identifier: String = "powerNapTimeIdentifier"
    var timeRemaining: TimeInterval? = TimerController.shared.timeRemaining

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TimerController.shared.delegate = self
    }
    
    
    func updateView() {
        updateButton()
        updateTimerLabel()
    }
    
    func updateButton() {
        
        if TimerController.shared.isOn {
            timerButton.setTitle("Stop Timer", for: .normal)
            timerButton.backgroundColor = UIColor(displayP3Red: 253/255, green: 143/255, blue: 137/255, alpha: 1.0)
        } else {
            timerButton.setTitle("Start Timer", for: .normal)
            timerButton.backgroundColor = UIColor(displayP3Red: 182/255, green: 255/255, blue: 177/255, alpha: 1.0)
        }
    }
    
    func updateTimerLabel() {
        
        timeLabel.text = TimerController.shared.timeAsString()
    }
    
    
    
    // Delegate Methods
    func timerSecondTick() {
        updateTimerLabel()
    }
    
    func timerCompleted() {
        updateView()
        presentAlertController()
    }
    
    func timerStopped() {
        updateView()
    }
    
    func presentAlertController() {
        
        var snoozeTextField: UITextField?
        let alertController = UIAlertController(title: "Wake Up!", message: "Time to wake Up.", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Don't snooze, wake up now and go to work, but just in case you can put in more minutes here."
            textField.keyboardType = .numberPad
            snoozeTextField = textField
        }
        present(alertController, animated: true)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        let snoozeAction = UIAlertAction(title: "Snooze", style: .default) { (_) in
            guard let snoozeTime = snoozeTextField?.text,
                  let time = TimeInterval(snoozeTime) else { return }
            TimerController.shared.startTimer(time: time + 1)
            self.updateView()
        }
        
        alertController.addAction(dismissAction)
        alertController.addAction(snoozeAction)
    }
    

    
    // IBActions
    @IBAction func timerButtonTapped(_ sender: UIButton) {
        
        let timerIsOn = TimerController.shared.isOn
        if timerIsOn {
            TimerController.shared.stopTimer()
            cancelLocalNotification()
        } else {
            TimerController.shared.startTimer(time: 5)
            scheduleLocalNotification()
        }
        
        updateButton()
    }
}

