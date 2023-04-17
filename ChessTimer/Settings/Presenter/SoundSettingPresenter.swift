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
    func updateTableView()
}

final class SoundSettingPresenter: SoundSettingProtocol {
    
    weak var view: SoundSettingViewProtocol?
    
    public var content: [[String: Bool]] = [[:]]
    
    private var soundsIsOn: Bool
    private var timeLeftWarning: Bool
    private var vibrationIsOn: Bool
    
    init(view: SoundSettingViewProtocol) {
        self.view = view
        self.soundsIsOn = UserDefaults.standard.bool(forKey: "soundIsOn")
        self.timeLeftWarning = UserDefaults.standard.bool(forKey: "timeLeftWarning")
        self.vibrationIsOn = UserDefaults.standard.bool(forKey: "vibrationIsOn")
        
        content = [["Sound": soundsIsOn, "Time left warning": timeLeftWarning],
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
        } else {
            soundsIsOn = false
        }
        
    }
    
    func updateTableView() {
        view?.updateView(content: content)
    }
    
    deinit {
        UserDefaults.standard.set(soundsIsOn, forKey: "soundIsOn")
        UserDefaults.standard.set(timeLeftWarning, forKey: "timeLeftWarning")
        UserDefaults.standard.set(vibrationIsOn, forKey: "vibrationIsOn")
    }
}
