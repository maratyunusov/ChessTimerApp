//
//  ViewController.swift
//  ChessTimer
//
//  Created by Marat Yunusov on 10.02.2023.
//

import UIKit

protocol MainViewProtocol: AnyObject {
    
}

/// Main view controller
final class MainViewController: UIViewController, MainViewProtocol {
    fileprivate enum PlayerSideColor {
        case classic
        case style1
    }
    
    var mainPresenter: MainViewPresenterProtocol?
    
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
    
    private let centerViewButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mainStackView)
        view.addSubview(centerViewButton)
        
        addConstraints()
        changePlayerSideColor(style: .style1)
        
        firstPlayerSideView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(firstPlayerTap)))
        secondPlayerSideView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(secondPlayerTap)))
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        centerViewButton.isHidden = true
    }
    
    @objc private func firstPlayerTap() {
        firstPlayerSideView.setupTimeButton.isHidden = true
        secondPlayerSideView.setupTimeButton.isHidden = true
        centerViewButton.isHidden = false
    }
    
    @objc private func secondPlayerTap() {
        firstPlayerSideView.setupTimeButton.isHidden = true
        secondPlayerSideView.setupTimeButton.isHidden = true
        centerViewButton.isHidden = false
    }
    
    private func addConstraints() {
        mainStackView.addArrangedSubview(firstPlayerSideView)
        mainStackView.addArrangedSubview(secondPlayerSideView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor),
            mainStackView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainStackView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            centerViewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerViewButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            centerViewButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/5),
            centerViewButton.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/5),
        ])
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupCenterButton()
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
    
    private func setupCenterButton() {
        centerViewButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        centerViewButton.tintColor = .systemGray2
        centerViewButton.imageView?.contentMode = .scaleToFill
        centerViewButton.imageEdgeInsets = UIEdgeInsets(top: centerViewButton.frame.width / 1.5,
                                                        left: centerViewButton.frame.width / 1.5,
                                                        bottom: centerViewButton.frame.width / 1.5,
                                                        right: centerViewButton.frame.width / 1.5)
        centerViewButton.layer.cornerRadius = centerViewButton.frame.width / 2
        centerViewButton.backgroundColor = .white
        centerViewButton.layer.borderWidth = 0.2
        centerViewButton.layer.borderColor = UIColor.systemGray2.withAlphaComponent(1).cgColor
    }
}

