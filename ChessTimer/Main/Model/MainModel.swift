//
//  MainModel.swift
//  ChessTimer
//
//  Created by Marat Yunusov on 15.02.2023.
//

import Foundation

struct MainModel {
    var hours: Int
    var minutes: Int
    var seconds: Int
    
    var tupleTime: (String, String, String) {
        return (String(hours), String(minutes), String(seconds))
    }
}
