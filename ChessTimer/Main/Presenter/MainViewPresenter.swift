//
//  MainViewPresenter.swift
//  ChessTimer
//
//  Created by Marat Yunusov on 12.02.2023.
//

import Foundation
import AudioToolbox

protocol MainViewPresenterProtocol: AnyObject {
    func setTime(firstPlayerTimer: Double, secondPlayerTimer: Double)
    func startTimerFirstPlayer()
    func startTimerSecondPlayer()
    func pauseTimerFirstPlayer()
    func pauseTimerSecondPlayer()
    func restart()
}

final class MainViewPresenter: MainViewPresenterProtocol, CountdownTimerDelegate {
    
    weak var mainView: MainViewProtocol?
    
    private var time: (Double, Double) = (0.0, 0.0)
    
    var firstPlayerCountdownTimer = CountdownTimer()
    var secondPlayerCountdownTimer = CountdownTimer()
    
    init(mainView: MainViewProtocol?) {
        self.mainView = mainView
        
        firstPlayerCountdownTimer.delegate = self
        secondPlayerCountdownTimer.delegate = self
    }
    
    func setTime(firstPlayerTimer: Double, secondPlayerTimer: Double) {
        firstPlayerCountdownTimer.duration = firstPlayerTimer
        secondPlayerCountdownTimer.duration = secondPlayerTimer
        time = (firstPlayerTimer, secondPlayerTimer)
    }
    
    func startTimerFirstPlayer() {
        secondPlayerCountdownTimer.start()
    }
    
    func startTimerSecondPlayer() {
        firstPlayerCountdownTimer.start()
    }

    func pauseTimerFirstPlayer() {
        secondPlayerCountdownTimer.pause()
    }
    
    func pauseTimerSecondPlayer() {
        firstPlayerCountdownTimer.pause()
    }
    
    func updateTimer() {
        let first = firstPlayerCountdownTimer.duration
        let second = secondPlayerCountdownTimer.duration
        mainView?.updateTimerPlayer(first: first, second: second)
        
        if first == 0 {
            endGame(timeIsOver: true)
        } else if second == 0 {
            endGame(timeIsOver: false)
        }
    }
    
    private func endGame(timeIsOver: Bool) {
        mainView?.gameOver(isFirst: timeIsOver)
        SoundsManager.shared.endGameSound()
        HapticManager.shared.endGameVibration()
    }
    
    func restart() {
        time = (UserDefaults.standard.double(forKey: "time"), UserDefaults.standard.double(forKey: "time"))
        firstPlayerCountdownTimer.duration = time.0
        secondPlayerCountdownTimer.duration = time.1
        mainView?.updateTimerPlayer(first: time.0, second: time.1)
    }
    
}
