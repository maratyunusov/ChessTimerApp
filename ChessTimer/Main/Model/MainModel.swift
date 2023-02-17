//
//  MainModel.swift
//  ChessTimer
//
//  Created by Marat Yunusov on 15.02.2023.
//

import Foundation

struct MainModel {
    let hours: Int
    let minutes: Int
    let seconds: Int
    
    var tupleTime: (String, String, String) {
        return (String(hours), String(minutes), String(seconds))
    }
}
