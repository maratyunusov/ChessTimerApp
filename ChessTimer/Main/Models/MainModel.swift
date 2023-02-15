//
//  MainModel.swift
//  ChessTimer
//
//  Created by Marat Yunusov on 15.02.2023.
//

import Foundation

struct MainModel {
    let hours: String = ""
    let minutes: String = ""
    let seconds: String = ""
    
    var tupleTime: (String, String, String) {
        return (hours, minutes, seconds)
    }
}
