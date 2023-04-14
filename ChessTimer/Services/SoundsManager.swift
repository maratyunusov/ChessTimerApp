//
//  SoundsManager.swift
//  ChessTimer
//
//  Created by Marat Yunusov on 13.04.2023.
//

import Foundation
import AVFoundation

struct SoundsManager {
    static var shared = SoundsManager()
    
    var isSoundsON: Bool = true
    
    var player: AVAudioPlayer?
    
    mutating func playSwitchPlayer(url: URL) {
        do {
            player = try AVAudioPlayer(contentsOf: url)
            if isSoundsON {
                player?.play()
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func endGameSound() {
        let endGameSound = SystemSoundID(1260)
        if isSoundsON {
            AudioServicesPlaySystemSound(endGameSound)
        }
    }
    
    
    
}
