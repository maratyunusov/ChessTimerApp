//
//  Extenstions.swift
//  ChessTimer
//
//  Created by Marat Yunusov on 16.02.2023.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            addSubview($0)
        }
    }
}

extension UIColor {
    static var tabBarItemAccent: UIColor {
        #colorLiteral(red: 0.2605186105, green: 0.2605186105, blue: 0.2605186105, alpha: 1)
    }
    static var mainWhite: UIColor {
        #colorLiteral(red: 0.6642269492, green: 0.6642268896, blue: 0.6642268896, alpha: 1)
    }
    static var tabBarItemLight: UIColor {
        #colorLiteral(red: 0.2605186105, green: 0.2605186105, blue: 0.2605186105, alpha: 0.5)
    }
}
