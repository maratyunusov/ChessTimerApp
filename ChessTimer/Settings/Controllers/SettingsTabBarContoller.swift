//
//  SettingTabBarContoller.swift
//  ChessTimer
//
//  Created by Marat Yunusov on 17.02.2023.
//

import UIKit

class SettingsTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 15.0, *) {
            view.backgroundColor = .systemMint
        } else {
            view.backgroundColor = .systemGray6
        }
        
        setupTabs()
        setTabBarAppearance()
    }
    
    private func setupTabs() {
        let gameModeVC = GameModeViewController()
        let backgroundColorVC = BackgroundColorViewController()
        viewControllers = [generateVC(gameModeVC,
                                      title: "Mode",
                                      image: UIImage(systemName: "hare")),
                           generateVC(backgroundColorVC,
                                      title: "Style",
                                      image: UIImage(systemName: "paintpalette"))]
    }
    
    private func generateVC(_ viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return viewController
    }
    
    private func setTabBarAppearance() {
        let positionOnX: CGFloat = 10
        let positionOnY: CGFloat = 14
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
        
        roundLayer.fillColor = UIColor.mainWhite.cgColor
        tabBar.tintColor = .tabBarItemAccent
        tabBar.unselectedItemTintColor = .tabBarItemLight
    }
}
