//
//  SoundSettingPresenter.swift
//  ChessTimer
//
//  Created by Marat Yunusov on 29.03.2023.
//

import Foundation

protocol SoundSettingProtocol: AnyObject {
    func didSelectCell(section: Int, row: Int)
    func soundMode(isOn: Bool)
    func vibrationMode(isOn: Bool)
    func updateTableView()
}

final class SoundSettingPresenter: SoundSettingProtocol {
    
    weak var view: SoundSettingViewProtocol?
    
    public var content: [[String: Bool]] = [[:]]
    
    private var soundsIsOn: Bool
    private var vibrationIsOn: Bool
    
    init(view: SoundSettingViewProtocol) {
        self.view = view
        self.soundsIsOn = UserDefaults.standard.bool(forKey: "soundIsOn")
        self.vibrationIsOn = UserDefaults.standard.bool(forKey: "vibrationIsOn")
        
        content = [["Sound": soundsIsOn],
                   ["Vibration": vibrationIsOn]]
        
        updateTableView()
    }
    
    func didSelectCell(section: Int, row: Int) {
        print(section, row)
        SoundsManager.shared.isSoundsON = false
    }
    
    func soundMode(isOn: Bool) {
        SoundsManager.shared.isSoundsON = isOn
        
        if isOn {
            soundsIsOn = true
            SoundsManager.shared.successSound()
            HapticManager.shared.notification(type: .success)
        } else {
            soundsIsOn = false
        }
        
        do {
            UserDefaults.standard.set(soundsIsOn, forKey: "soundIsOn")
        }
    }
    
    func vibrationMode(isOn: Bool) {
        HapticManager.shared.isVibrationON = isOn
        
        if isOn {
            vibrationIsOn = true
            HapticManager.shared.notification(type: .success)
        } else {
            vibrationIsOn = false
        }
        
        do {
            UserDefaults.standard.set(vibrationIsOn, forKey: "vibrationIsOn")
        }
    }
    
    func updateTableView() {
        view?.updateView(content: content)
    }
}
