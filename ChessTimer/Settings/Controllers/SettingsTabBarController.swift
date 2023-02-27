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
   
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setTabBarAppearance()
    }
   
    //MARK: - Configure TabBarContoller
    private func setupTabs() {
        viewControllers = [generateVC(gameModeVC,
                                      title: "Mode",
                                      image: UIImage(systemName: "hare")),
//                           generateVC(backgroundColorVC,
//                                      title: "Style",
//                                      image: UIImage(systemName: "paintpalette"))
        ]
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
        tabBar.barTintColor = .clear
    }
}
