//
//  SettingTabBarContoller.swift
//  ChessTimer
//
//  Created by Marat Yunusov on 17.02.2023.
//

import UIKit

final class SettingsTabBarController: UITabBarController {
    
    let gameModeVC = GameModeViewController()
    let backgroundColorVC = BackgroundColorViewController()
    let soundSettingVC = SoundSettingViewController()
    
    let notificationCenter = NotificationCenter.default
    
    private var currentPageStyle = UserDefaults.standard.integer(forKey: "currentStyle")
   
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationCenter.addObserver(self, selector: #selector(changeColor), name: .changeThemeColorNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        
        setupTabs()
        setTabBarAppearance(indexColor: currentPageStyle)
    }
    
    @objc func changeColor(notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Int] else { return }
        guard let indexColor = userInfo["index"] else { return }
        currentPageStyle = indexColor
    }
   
    //MARK: - Configure TabBarContoller
    private func setupTabs() {
        viewControllers = [generateVC(gameModeVC,
                                      title: "Mode",
                                      image: UIImage(systemName: "hare")),
                           generateVC(backgroundColorVC,
                                      title: "Style",
                                      image: UIImage(systemName: "paintpalette")),
                           generateVC(soundSettingVC,
                                      title: "Sound",
                                      image: UIImage(systemName: "speaker.wave.3"))
        ]
    }
    
    private func generateVC(_ viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return viewController
    }
    
    private func setTabBarAppearance(indexColor: Int) {
        let setCornerRadiusTabBar = tabBar.frame.height / 2
        
        switch indexColor {
        case 0:
            tabBar.backgroundColor = ColorSet.classic2
            tabBar.tintColor = .white
            tabBar.unselectedItemTintColor = .mainWhite
            tabBar.barTintColor = .clear
            tabBar.layer.cornerRadius = setCornerRadiusTabBar
        case 1:
            tabBar.backgroundColor = ColorSet.styleOne2
            tabBar.tintColor = .white
            tabBar.unselectedItemTintColor = #colorLiteral(red: 0.8374214172, green: 0.8374213576, blue: 0.8374213576, alpha: 1)
            tabBar.barTintColor = .clear
            tabBar.layer.cornerRadius = setCornerRadiusTabBar
        case 2:
            tabBar.backgroundColor = ColorSet.styleTwo2
            tabBar.tintColor = .white
            tabBar.unselectedItemTintColor = #colorLiteral(red: 0.8374214172, green: 0.8374213576, blue: 0.8374213576, alpha: 1)
            tabBar.barTintColor = .clear
            tabBar.layer.cornerRadius = setCornerRadiusTabBar
        default: break
        }
    }
}

extension SettingsTabBarController: BackgroundStyleDelegate {
    func changeBackgroundStyle(index: Int) {
        setTabBarAppearance(indexColor: index)
    }
}
