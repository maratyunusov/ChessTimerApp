//
//  SettingsBuilder.swift
//  ChessTimer
//
//  Created by Marat Yunusov on 16.02.2023.
//

import UIKit

final class SettingsBuilder {
        static func build() -> UIViewController {
            let settingsViewController = SettingsTabBarController()
//            let mainPresenter = MainViewPresenter(mainView: mainViewController)
//            mainViewController.mainPresenter = mainPresenter
            return settingsViewController
    }
}
