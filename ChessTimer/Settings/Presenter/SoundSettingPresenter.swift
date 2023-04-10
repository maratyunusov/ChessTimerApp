//
//  SoundSettingPresenter.swift
//  ChessTimer
//
//  Created by Marat Yunusov on 29.03.2023.
//

import Foundation

protocol SoundSettingProtocol: AnyObject {
    func didSelectCell(section: Int, row: Int)
    func updateTableView()
}

final class SoundSettingPresenter: SoundSettingProtocol {
    
    var view: SoundSettingViewProtocol?
    
    private let content: [[String: Bool]] = [["Sound": true, "Time left warning": false],
                                             ["Vibration": true]]
    
    private var soundsIsOn = true
    private var timeLeftWarning = true
    private var vibrationIsOn = true
    
    init(view: SoundSettingViewProtocol) {
        self.view = view
        updateTableView()
    }
    
    func didSelectCell(section: Int, row: Int) {
        
    }
    
    func updateTableView() {
        view?.updateView(content: content)
    }
}
