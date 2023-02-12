//
//  ViewController.swift
//  ChessTimer
//
//  Created by Marat Yunusov on 10.02.2023.
//

import UIKit

protocol MainViewControllerProtocol: AnyObject {
    
}

/// Main view controller
final class MainViewController: UIViewController {
    enum PlayerSideColor {
        case classic
        case style1
    }
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let firstPlayerSideView: MainPlayerSideView = {
        let sideView = MainPlayerSideView(transformSideView: .reverse)
        return sideView
    }()
    
    private let secondPlayerSideView: MainPlayerSideView = {
        let sideView = MainPlayerSideView(transformSideView: .normal)
        return sideView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mainStackView)
        
        addConstraints()
        changePlayerSideColor(style: .classic)
    }
    
    private func addConstraints() {
        mainStackView.addArrangedSubview(firstPlayerSideView)
        mainStackView.addArrangedSubview(secondPlayerSideView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor),
            mainStackView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainStackView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func changePlayerSideColor(style: PlayerSideColor) {
        switch style {
        case .classic:
            firstPlayerSideView.backgroundColor = .systemGray5
            secondPlayerSideView.backgroundColor = .systemGray6
        case .style1:
            firstPlayerSideView.backgroundColor = .systemRed
            secondPlayerSideView.backgroundColor = .systemBlue
        }
    }
}
