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
    
    let notificationCenter = NotificationCenter.default
    
    private var currentPageStyle = UserDefaults.standard.integer(forKey: "currentStyle")
   
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setTabBarAppearance(indexColor: currentPageStyle)
        
        notificationCenter.addObserver(self, selector: #selector(changeColor), name: .changeThemeColorNotification, object: nil)
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
                                      image: UIImage(systemName: "paintpalette"))
        ]
    }
    
    private func generateVC(_ viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return viewController
    }
    
    private func setTabBarAppearance(indexColor: Int) {
        let positionOnX: CGFloat = 10
        let positionOnY: CGFloat = 10
        let width = tabBar.bounds.width - positionOnX * 2
        let height = tabBar.bounds.height + positionOnY * 2
        
        let roundLayer = CAShapeLayer()
        
        let bezierPath = UIBezierPath(roundedRect: CGRect(x: positionOnX,
                                                          y: tabBar.bounds.minY - positionOnY,
                                                          width: width,
                                                          height: height),
                                      cornerRadius: height / 2
        )
        roundLayer.path = bezierPath.cgPath
        tabBar.layer.insertSublayer(roundLayer, at: 0)
        tabBar.itemWidth = width / 5
        tabBar.itemPositioning = .centered
        
        switch indexColor {
        case 0:
            roundLayer.fillColor = ColorSet.classic2.cgColor
            tabBar.tintColor = .white
            tabBar.unselectedItemTintColor = .mainWhite
            tabBar.barTintColor = .clear
        case 1:
            roundLayer.fillColor = ColorSet.styleOne2.cgColor
            tabBar.tintColor = .white
            tabBar.unselectedItemTintColor = #colorLiteral(red: 0.8374214172, green: 0.8374213576, blue: 0.8374213576, alpha: 1)
            tabBar.barTintColor = .clear
        case 2:
            roundLayer.fillColor = ColorSet.styleTwo2.cgColor
            tabBar.tintColor = .white
            tabBar.unselectedItemTintColor = #colorLiteral(red: 0.8374214172, green: 0.8374213576, blue: 0.8374213576, alpha: 1)
            tabBar.barTintColor = .clear
        default: break
        }
    }
}
