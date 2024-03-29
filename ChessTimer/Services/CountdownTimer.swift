//
//  CountdownTimer.swift
//  ChessTimer
//
//  Created by Marat Yunusov on 19.02.2023.
//

import Foundation

protocol CountdownTimerDelegate: AnyObject {
    func updateTimer()
}

/// Timer class
final class CountdownTimer {
    
    weak var delegate: CountdownTimerDelegate?
    
    public var seconds: Double = 600.0
    public var duration: Double = 600.0
    
    private var counterTimer: Int = 0
    
    lazy var timer: Timer = {
        let timer = Timer()
        return timer
    }()
    
    public func setTimer(hours:Int, minutes:Int, seconds:Int) {
        let hoursToSeconds = hours * 3600
        let minutesToSeconds = minutes * 60
        let secondsToSeconds = seconds
        
        let seconds = secondsToSeconds + minutesToSeconds + hoursToSeconds
        self.seconds = Double(seconds)
        self.duration = Double(seconds)
    }
    
    public func start() {
        runTimer()
    }
    
    public func pause() {
        timer.invalidate()
    }
    
    fileprivate func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc fileprivate func updateTimer() {
        if duration == 0.0 {
            timer.invalidate()
            timerDone()
        } else {
            if counterTimer == 100 {
                counterTimer = 0
                duration -= 1
                delegate?.updateTimer()
            }
            counterTimer += 1
        }
    }
    
    fileprivate func timerDone() {
        timer.invalidate()
        duration = seconds
    }
}
