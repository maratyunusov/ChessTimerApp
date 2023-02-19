//
//  ViewController.swift
//  ChessTimer
//
//  Created by Marat Yunusov on 10.02.2023.
//

import UIKit

protocol MainViewProtocol: AnyObject {
    func saveTimers()
    func didStartTimer()
    func updateTimerPlayer(first: Double, second: Double)
}

/// Main view controller
final class MainViewController: UIViewController, MainViewProtocol {
    fileprivate enum PlayerSideColor {
        case classic
        case style1
    }
    
    var mainPresenter: MainViewPresenterProtocol?
    
    var isTimerDidStart = false
    var isHiddenPauseButton = false
    
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
    
    private let pauseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let settingButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let restartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        firstPlayerSideView.delegate = self
        secondPlayerSideView.delegate = self
        
        view.addSubviews(mainStackView,
                         settingButton,
                         restartButton,
                         pauseButton
                         )
        
        addConstraints()
        changePlayerSideColor(style: .classic)
        setupButtons()
        
        firstPlayerSideView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(firstPlayerTap)))
        secondPlayerSideView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(secondPlayerTap)))
        
        pauseButton.addTarget(self, action: #selector(tapPauseButton), for: .touchUpInside)
        settingButton.addTarget(self, action: #selector(tapSettingButton), for: .touchUpInside)
        restartButton.addTarget(self, action: #selector(tapRestartButton), for: .touchUpInside)
    }
    
    func didStartTimer() {
        if !isTimerDidStart {
            mainPresenter?.startTimerSecondPlayer()
            isTimerDidStart = true
            mainPresenter?.pauseTimerFirstPlayer()
            firstPlayerSideView.isUserInteractionEnabled = true
            secondPlayerSideView.isUserInteractionEnabled = false
        } else {
            mainPresenter?.pauseTimerSecondPlayer()
            isTimerDidStart = false
            mainPresenter?.startTimerFirstPlayer()
            firstPlayerSideView.isUserInteractionEnabled = false
            secondPlayerSideView.isUserInteractionEnabled = true
        }
    }
    
    func saveTimers() {
        mainPresenter?.setTime(firstPlayerTimer: firstPlayerSideView.time,
                               secondPlayerTimer: secondPlayerSideView.time)
    }
    
    func updateTimerPlayer(first: Double, second: Double) {
        firstPlayerSideView.time = first
        secondPlayerSideView.time = second
    }
    
    //MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pauseButton.isHidden = true
        settingButton.isHidden = false
        restartButton.isHidden = true
    }
 
    //MARK: - Actions #selector()
    @objc private func tapPauseButton() {
        if isHiddenPauseButton == true {
            isHiddenPauseButton = false
            firstPlayerSideView.isUserInteractionEnabled = true
            secondPlayerSideView.isUserInteractionEnabled = true
//            mainPresenter?.startTimerFirstPlayer()
//            mainPresenter?.startTimerSecondPlayer()
        } else {
            isHiddenPauseButton = true
            firstPlayerSideView.isUserInteractionEnabled = false
            secondPlayerSideView.isUserInteractionEnabled = false
            mainPresenter?.pauseTimerFirstPlayer()
            mainPresenter?.pauseTimerSecondPlayer()
        }
        showExtraButton(state: isHiddenPauseButton)
    }
    
    @objc private func tapSettingButton() {
        let settingsVC = SettingsBuilder.build()
        settingsVC.modalTransitionStyle = .flipHorizontal
        present(settingsVC, animated: true)
    }
    
    @objc private func tapRestartButton() {
        showAlertRestartConfirm { [weak self] in
            guard let self = self else { return }
            self.mainPresenter?.restart()
            self.isTimerDidStart = false
            self.firstPlayerSideView.isUserInteractionEnabled = true
            self.secondPlayerSideView.isUserInteractionEnabled = true
            self.firstPlayerSideView.time = 300
            self.secondPlayerSideView.time = 300
            self.pauseButton.isHidden = true
            self.settingButton.isHidden = false
            self.restartButton.isHidden = true
            self.pauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            self.isHiddenPauseButton = false
            self.showExtraButton(state: self.isHiddenPauseButton)
            self.firstPlayerSideView.tapStartLabel.isHidden = false
            self.secondPlayerSideView.tapStartLabel.isHidden = false
            self.firstPlayerSideView.setupTimeButton.isHidden = false
            self.secondPlayerSideView.setupTimeButton.isHidden = false
        }
    }
    
    @objc private func firstPlayerTap() {
        firstPlayerSideView.setupTimeButton.isHidden = true
        secondPlayerSideView.setupTimeButton.isHidden = true
        firstPlayerSideView.tapStartLabel.isHidden = true
        secondPlayerSideView.tapStartLabel.isHidden = true
        pauseButton.isHidden = false
        settingButton.isHidden = true
        restartButton.isHidden = true
        isHiddenPauseButton = false
        
        didStartTimer()
    }
    
    @objc private func secondPlayerTap() {
        firstPlayerSideView.setupTimeButton.isHidden = true
        secondPlayerSideView.setupTimeButton.isHidden = true
        firstPlayerSideView.tapStartLabel.isHidden = true
        secondPlayerSideView.tapStartLabel.isHidden = true
        pauseButton.isHidden = false
        settingButton.isHidden = true
        restartButton.isHidden = true
        isHiddenPauseButton = false
        
        didStartTimer()
    }
}

//MARK: - EXTENSIONS
extension MainViewController {
    
    //MARK: - Alerts
    private func showAlertRestartConfirm(completion: @escaping () -> Void) {
        let alert = UIAlertController(title: "Restart", message: "You are sure?", preferredStyle: .actionSheet)
        let actionConfirme = UIAlertAction(title: "Confirme", style: .default) { confirme in
            completion()
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(actionConfirme)
        alert.addAction(actionCancel)
        present(alert, animated: true)
    }
    
    //MARK: - Constraints and setup UI
    
    /// Setup setting and restart buttons with animating
    private func showExtraButton(state: Bool) {
        UIView.animate(withDuration: 0.4) { [weak self] in
            guard let self = self else { return }
            if state {
                self.settingButton.isHidden = false
                self.restartButton.isHidden = false
                self.settingButton.transform = CGAffineTransform(translationX: self.view.frame.width / 4, y: 0)
                self.restartButton.transform = CGAffineTransform(translationX: -self.view.frame.width / 4, y: 0)
                self.pauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            } else {
                self.settingButton.transform = CGAffineTransform(translationX: 0, y: 0)
                self.restartButton.transform = CGAffineTransform(translationX: 0, y: 0)
                self.pauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            }
        }
    }
    
    private func addConstraints() {
        mainStackView.addArrangedSubview(firstPlayerSideView)
        mainStackView.addArrangedSubview(secondPlayerSideView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor),
            mainStackView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainStackView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            pauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pauseButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            pauseButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/5),
            pauseButton.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/5),
            
            settingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            settingButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            settingButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/7.5),
            settingButton.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/7.5),
            
            restartButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            restartButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            restartButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/7.5),
            restartButton.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/7.5),
        ])
    }
    
    private func changePlayerSideColor(style: PlayerSideColor) {
        switch style {
        case .classic:
            firstPlayerSideView.backgroundColor = .tabBarItemLight
            secondPlayerSideView.backgroundColor = .tabBarItemAccent
        case .style1:
            firstPlayerSideView.backgroundColor = .systemRed
            secondPlayerSideView.backgroundColor = .systemBlue
        }
    }
    
    private func setupButtons() {
        //Pause Button
        pauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        pauseButton.tintColor = .tabBarItemAccent
        pauseButton.imageView?.contentMode = .scaleToFill
        pauseButton.imageEdgeInsets = UIEdgeInsets(top: pauseButton.frame.width / 1.5,
                                                   left: pauseButton.frame.width / 1.5,
                                                   bottom: pauseButton.frame.width / 1.5,
                                                   right: pauseButton.frame.width / 1.5
        )
        pauseButton.layer.cornerRadius = pauseButton.frame.width / 2
        pauseButton.backgroundColor = .white
        pauseButton.layer.borderWidth = 0.2
        pauseButton.layer.borderColor = UIColor.systemGray2.withAlphaComponent(1).cgColor
        
        //Setting Button
        settingButton.setImage(UIImage(systemName: "gear"), for: .normal)
        settingButton.tintColor = .tabBarItemAccent
        settingButton.imageView?.contentMode = .scaleToFill
        settingButton.imageEdgeInsets = UIEdgeInsets(top: settingButton.frame.width / 1.2,
                                                     left: settingButton.frame.width / 1.2,
                                                     bottom: settingButton.frame.width / 1.2,
                                                     right: settingButton.frame.width / 1.2
        )
        settingButton.layer.cornerRadius = settingButton.frame.width / 2
        settingButton.backgroundColor = .white
        settingButton.layer.borderWidth = 0.2
        settingButton.layer.borderColor = UIColor.systemGray2.withAlphaComponent(1).cgColor
        
        //Restart Button
        restartButton.setImage(UIImage(systemName: "gobackward"), for: .normal)
        restartButton.tintColor = .tabBarItemAccent
        restartButton.imageView?.contentMode = .scaleToFill
        restartButton.imageEdgeInsets = UIEdgeInsets(top: restartButton.frame.width / 1.2,
                                                     left: restartButton.frame.width / 1.2,
                                                     bottom: restartButton.frame.width / 1.2,
                                                     right: restartButton.frame.width / 1.2
        )
        restartButton.clipsToBounds = true
        restartButton.layer.cornerRadius = restartButton.frame.width / 2
        restartButton.backgroundColor = .white
        restartButton.layer.borderWidth = 0.2
        restartButton.layer.borderColor = UIColor.systemGray2.withAlphaComponent(1).cgColor
    }
}

