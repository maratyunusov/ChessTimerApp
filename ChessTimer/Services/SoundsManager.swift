//
//  SoundsManager.swift
//  ChessTimer
//
//  Created by Marat Yunusov on 13.04.2023.
//

import Foundation
import AVFoundation
import UIKit

struct SoundsManager {
    static var shared = SoundsManager()
    
    var isSoundsON: Bool = UserDefaults.standard.bool(forKey: "soundIsOn")
    
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
    
    func successSound() {
        AudioServicesPlaySystemSound(SystemSoundID(1114))
    }
    
    func endGameSound() {
        if isSoundsON {
            AudioServicesPlaySystemSound(SystemSoundID(1260))
        }
    }
}
