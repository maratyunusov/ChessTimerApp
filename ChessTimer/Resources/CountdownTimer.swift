//
//  CountdownTimer.swift
//  ChessTimer
//
//  Created by Marat Yunusov on 19.02.2023.
//

import Foundation

protocol CountdownTimerDelegate: AnyObject {
    
//    func countdownTimerDone()
//    func countdownTime(time: (hours: String, minutes: String, seconds: String))
    func updateTimer()
}

class CountdownTimer {
    
    weak var delegate: CountdownTimerDelegate?
    
    fileprivate var seconds: Double = 300.0
    public var duration: Double = 300.0
    
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
        
        //delegate?.countdownTime(time: timeString(time: TimeInterval(ceil(duration))))
    }
    
    public func start() {
        runTimer()
    }
    
    public func pause() {
        timer.invalidate()
    }
    
    public func stop() {
        timer.invalidate()
        duration = seconds
        //delegate?.countdownTime(time: timeString(time: TimeInterval(ceil(duration))))
    }
    
    fileprivate func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc fileprivate func updateTimer(){
        if duration < 0.0 {
            timer.invalidate()
            timerDone()
        } else {
            duration -= 1
            //print(TimeInterval(duration))
            //delegate?.countdownTime(time: timeString(time: TimeInterval(ceil(duration))))
            delegate?.updateTimer()
        }
    }
    
    fileprivate func timeString(time:TimeInterval) -> (hours: String, minutes:String, seconds:String) {
        
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        return (hours: String(format:"%02i", hours), minutes: String(format:"%02i", minutes), seconds: String(format:"%02i", seconds))
    }
    
    fileprivate func timerDone() {
        timer.invalidate()
        duration = seconds
        //delegate?.countdownTimerDone()
    }
}
