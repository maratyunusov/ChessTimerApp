//
//  HapticManager.swift
//  ChessTimer
//
//  Created by Marat Yunusov on 19.04.2023.
//

import UIKit
import AudioToolbox

struct HapticManager {
    static var shared = HapticManager()
    
    var isVibrationON: Bool = UserDefaults.standard.bool(forKey: "vibrationIsOn")
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    private func defaultVibrate() {
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate)) 
    }
    
    func endGameVibration() {
        if isVibrationON {
            defaultVibrate()
        }
    }
    
    
}
