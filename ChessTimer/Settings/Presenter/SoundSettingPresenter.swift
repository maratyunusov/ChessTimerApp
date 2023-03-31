//
//  SoundSettingPresenter.swift
//  ChessTimer
//
//  Created by Marat Yunusov on 29.03.2023.
//

import Foundation

protocol SoundSettingProtocol: AnyObject {
    func didSelectCell(index: Int)
}

final class SoundSettingPresenter: SoundSettingProtocol {
    
    var view: SoundSettingViewProtocol?
    
    private var soundsIsOn = ("Sound", true) {
        didSet {
            if soundsIsOn.1 == false {
                timeLeftWarning.1 = false
            }
        }
    }
    private var timeLeftWarning = ("Time left warning", true)
    private var vibrationIsOn = ("Vibration", true)
    
    init(view: SoundSettingViewProtocol) {
        self.view = view
    }
    
    func didSelectCell(index: Int) {
        
    }
    
}
