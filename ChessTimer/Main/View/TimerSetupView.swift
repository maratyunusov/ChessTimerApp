//
//  TimerSetupView.swift
//  ChessTimer
//
//  Created by Marat Yunusov on 11.02.2023.
//

import UIKit

final class TimerSetupView: UIPickerView {
    
    /// Arrays in array: hours, minutes, seconds.
    private var timeArray: [[String]] = []
    
    public var timerTuple: (String, String, String) = ("00","00","00")
    
    private let timerPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        timeArray = [Array(0...10).map{String($0)},
                     Array(0...59).map{String($0)},
                     Array(0...59).map{String($0)}
        ]
        
        dataSource = self
        delegate = self
        
        addSubview(timerPickerView)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        timerPickerView.subviews.forEach { view in
            view.backgroundColor = .clear
        }
    }
}

extension TimerSetupView: UIPickerViewDataSource, UIPickerViewDelegate {
    //DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return timeArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return timeArray[0].count
        case 1: return timeArray[1].count
        case 2: return timeArray[2].count
        default:
            break
        }
        return 0
    }
    
    //Delegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            timerTuple.0 = timeArray[0][row]
        case 1:
            timerTuple.1 = timeArray[1][row]
        case 2:
            timerTuple.2 = timeArray[2][row]
        default:
            break
        }
        
        
        
//        switch component {
//        case 0:
//            if Int(timeArray[0][row])! < 10 {
//                timerTuple.0 = "0\(timeArray[0][row])"
//            } else {
//                timerTuple.0 = "\(timeArray[0][row])"
//            }
//        case 1:
//            if Int(timeArray[1][row])! < 10 {
//                timerTuple.1 = "0\(timeArray[1][row])"
//            } else {
//                timerTuple.1 = "\(timeArray[1][row])"
//            }
//        case 2:
//            if Int(timeArray[2][row])! < 10 {
//                timerTuple.2 = "0\(timeArray[2][row])"
//            } else {
//                timerTuple.2 = "\(timeArray[2][row])"
//            }
//        default:
//            break
//        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return timeArray[0][row]
        case 1:
            return timeArray[1][row]
        case 2:
            return timeArray[2][row]
        default:
            break
        }
        return ""
    }
}

