//
//  MainBuilder.swift
//  ChessTimer
//
//  Created by Marat Yunusov on 15.02.2023.
//

import UIKit

final class MainBuilder {
    static func build() -> UIViewController {
        let mainViewController = MainViewController()
        let mainPresenter = MainViewPresenter(mainView: mainViewController)
        mainViewController.mainPresenter = mainPresenter
        return mainViewController
    }
}
