//
//  TimerSetupView.swift
//  ChessTimer
//
//  Created by Marat Yunusov on 11.02.2023.
//

import UIKit

final class TimerSetupView: UIPickerView {
    
    private let timerPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        dataSource = self
        delegate = self
        
        addSubview(timerPickerView)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

extension TimerSetupView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        return 10
    }
}

