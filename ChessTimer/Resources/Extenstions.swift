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
