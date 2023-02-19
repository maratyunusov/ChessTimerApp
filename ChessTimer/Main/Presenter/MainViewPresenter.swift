//
//  MainViewPresenter.swift
//  ChessTimer
//
//  Created by Marat Yunusov on 12.02.2023.
//

import Foundation

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
    
    let time: Double = 0.0
    
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
    }
    
    func startTimerFirstPlayer() {
        firstPlayerCountdownTimer.start()
        
    }
    
    func startTimerSecondPlayer() {
        secondPlayerCountdownTimer.start()
    }

    func pauseTimerFirstPlayer() {
        firstPlayerCountdownTimer.pause()
        
    }
    
    func pauseTimerSecondPlayer() {
        secondPlayerCountdownTimer.pause()
    }
    
    func updateTimer() {
        let first = firstPlayerCountdownTimer.duration
        let second = secondPlayerCountdownTimer.duration
        mainView?.updateTimerPlayer(first: first, second: second)
    }
    
    func restart() {
        firstPlayerCountdownTimer.duration = 300
        secondPlayerCountdownTimer.duration = 300
    }
    
}
