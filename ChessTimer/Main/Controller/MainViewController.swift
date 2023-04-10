//
//  ViewController.swift
//  ChessTimer
//
//  Created by Marat Yunusov on 10.02.2023.
//

import UIKit

protocol MainViewProtocol: AnyObject {
    func setChooseTimerMode(time: Double)
    func saveTimers()
    func didStartTimer()
    func updateTimerPlayer(first: Double, second: Double)
    func gameOver(isFirst: Bool)
}

/// Main view controller
final class MainViewController: UIViewController, MainViewProtocol, BackgroundStyleDelegate {
    fileprivate enum PlayerSideColor: Int {
        case classic
        case style1
        case style2
    }
    
    var mainPresenter: MainViewPresenterProtocol?
    
    private var start: Bool = false
    private var currentTime: Double = 0.0
    fileprivate var currentStyle: PlayerSideColor = .classic
    var currentBackgroundStyle: (UIColor, UIColor, UIColor)?
    
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
        
        changePlayerSideColor(style: PlayerSideColor.init(rawValue: UserDefaults.standard.integer(forKey: "currentStyle")) ?? .classic)
        
        setupButtons()
        
        firstPlayerSideView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(firstPlayerTap)))
        secondPlayerSideView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(secondPlayerTap)))
        
        pauseButton.addTarget(self, action: #selector(tapPauseButton), for: .touchUpInside)
        settingButton.addTarget(self, action: #selector(tapSettingButton), for: .touchUpInside)
        restartButton.addTarget(self, action: #selector(tapRestartButton), for: .touchUpInside)
        
        let userDefaultTime = UserDefaults.standard.double(forKey: "time")
        setChooseTimerMode(time: userDefaultTime)
    }
    
    //MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pauseButton.isHidden = true
        settingButton.isHidden = false
        restartButton.isHidden = true
    }
    
    //MARK: - Protocol methods
    func didStartTimer() {
        start = true
        if !isTimerDidStart {
            mainPresenter?.startTimerSecondPlayer()
            mainPresenter?.pauseTimerFirstPlayer()
            isTimerDidStart = true
            firstPlayerSideView.isUserInteractionEnabled = true
            secondPlayerSideView.isUserInteractionEnabled = false
            firstPlayerSideView.backgroundColor = currentBackgroundStyle?.2
            secondPlayerSideView.backgroundColor = currentBackgroundStyle?.1
        } else {
            mainPresenter?.startTimerFirstPlayer()
            mainPresenter?.pauseTimerSecondPlayer()
            isTimerDidStart = false
            firstPlayerSideView.isUserInteractionEnabled = false
            secondPlayerSideView.isUserInteractionEnabled = true
            secondPlayerSideView.backgroundColor = currentBackgroundStyle?.2
            firstPlayerSideView.backgroundColor = currentBackgroundStyle?.0
        }
    }
    
    func saveTimers() {
        mainPresenter?.setTime(firstPlayerTimer: firstPlayerSideView.time,
                               secondPlayerTimer: secondPlayerSideView.time)
    }
    
    func setChooseTimerMode(time: Double) {
        if !start {
            firstPlayerSideView.time = time
            secondPlayerSideView.time = time
            mainPresenter?.setTime(firstPlayerTimer: time, secondPlayerTimer: time)
            currentTime = time
            
            changePlayerSideColor(style: currentStyle)
            restartGameUpdateUI()
        }
    }
    
    func updateTimerPlayer(first: Double, second: Double) {
        firstPlayerSideView.time = first
        secondPlayerSideView.time = second
    }
    
    func gameOver(isFirst: Bool) {
        if isFirst {
            firstPlayerSideView.backgroundColor = .systemRed
        } else {
            secondPlayerSideView.backgroundColor = .systemRed
        }
        
        firstPlayerSideView.isUserInteractionEnabled = false
        secondPlayerSideView.isUserInteractionEnabled = false
        tapRestartButton()
    }
    
    //MARK: - Delegates
    func changeBackgroundStyle(index: Int) {
        if let style = PlayerSideColor.init(rawValue: index) {
            currentStyle = style
            changePlayerSideColor(style: style)

            guard start else { return }
            if isTimerDidStart {
                firstPlayerSideView.backgroundColor = currentBackgroundStyle?.2
                secondPlayerSideView.backgroundColor = currentBackgroundStyle?.1
            } else {
                secondPlayerSideView.backgroundColor = currentBackgroundStyle?.2
                firstPlayerSideView.backgroundColor = currentBackgroundStyle?.0
            }
        }
    }
    
    //MARK: - Actions #selector()
    @objc private func tapPauseButton() {
        if isHiddenPauseButton == true {
            isHiddenPauseButton = false
            if !isTimerDidStart {
                secondPlayerSideView.isUserInteractionEnabled = true
                mainPresenter?.startTimerFirstPlayer()
            } else {
                firstPlayerSideView.isUserInteractionEnabled = true
                mainPresenter?.startTimerSecondPlayer()
            }
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
        guard let settingsVC = SettingsBuilder.build() as? SettingsTabBarController else { return }
        settingsVC.gameModeVC.delegate = self
        settingsVC.backgroundColorVC.delegate = self
        settingsVC.modalTransitionStyle = .coverVertical
        present(settingsVC, animated: true)
    }
    
    @objc private func tapRestartButton() {
        showAlertRestartConfirm { [weak self] in
            self?.restartGameUpdateUI()
        }
    }
    
    @objc private func firstPlayerTap() {
        didPlayerTapped(isTimer: true)
    }
    
    @objc private func secondPlayerTap() {
        didPlayerTapped(isTimer: false)
    }
    
    private func didPlayerTapped(isTimer: Bool) {
        if secondPlayerSideView.isActivePicker == false && firstPlayerSideView.isActivePicker == false {
            firstPlayerSideView.setupTimeButton.isHidden = true
            secondPlayerSideView.setupTimeButton.isHidden = true
            firstPlayerSideView.tapStartLabel.isHidden = true
            secondPlayerSideView.tapStartLabel.isHidden = true
            pauseButton.isHidden = false
            settingButton.isHidden = true
            restartButton.isHidden = true
            isHiddenPauseButton = false
            isTimerDidStart = isTimer
            
            didStartTimer()
        }
    }
}

//MARK: - EXTENSIONS
extension MainViewController {
    
    //MARK: - Alerts
    private func showAlertRestartConfirm(completion: @escaping () -> Void) {
        let alert = UIAlertController(title: "RESTART", message: "", preferredStyle: .alert)
        let actionConfirme = UIAlertAction(title: "Confirme", style: .default) { confirme in
            completion()
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .default)
        alert.addAction(actionConfirme)
        alert.addAction(actionCancel)
        present(alert, animated: true)
    }
    
    private func restartGameUpdateUI() {
        start = false
        mainPresenter?.restart()
        isTimerDidStart = false
        firstPlayerSideView.isUserInteractionEnabled = true
        secondPlayerSideView.isUserInteractionEnabled = true
        pauseButton.isHidden = true
        settingButton.isHidden = false
        restartButton.isHidden = true
        pauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        isHiddenPauseButton = false
        showExtraButton(state: isHiddenPauseButton)
        changePlayerSideColor(style: currentStyle)
        firstPlayerSideView.tapStartLabel.isHidden = false
        secondPlayerSideView.tapStartLabel.isHidden = false
        firstPlayerSideView.setupTimeButton.isHidden = false
        secondPlayerSideView.setupTimeButton.isHidden = false
    }
    
    private func changePlayerSideColor(style: PlayerSideColor) {
        switch style {
        case .classic:
            currentStyle = .classic
            firstPlayerSideView.backgroundColor = ColorSet.classic1
            secondPlayerSideView.backgroundColor = ColorSet.classic2
            currentBackgroundStyle = (UIColor.tabBarItemLight,
                                      UIColor.tabBarItemAccent,
                                      UIColor.systemGreen)
        case .style1:
            currentStyle = .style1
            firstPlayerSideView.backgroundColor = ColorSet.styleOne1
            secondPlayerSideView.backgroundColor = ColorSet.styleOne2
            currentBackgroundStyle = (firstPlayerSideView.backgroundColor ?? .clear,
                                      secondPlayerSideView.backgroundColor ?? .clear,
                                      UIColor.systemGreen)
        case .style2:
            currentStyle = .style2
            firstPlayerSideView.backgroundColor = ColorSet.styleTwo1
            secondPlayerSideView.backgroundColor = ColorSet.styleTwo2
            currentBackgroundStyle = (firstPlayerSideView.backgroundColor ?? .clear,
                                      secondPlayerSideView.backgroundColor ?? .clear,
                                      UIColor.systemGreen)
        }
        
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
        pauseButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        pauseButton.layer.shadowRadius = 10
        pauseButton.layer.shadowOpacity = 1
        pauseButton.layer.shadowColor = UIColor.black.cgColor
        
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
        settingButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        settingButton.layer.shadowRadius = 10
        settingButton.layer.shadowOpacity = 1
        settingButton.layer.shadowColor = UIColor.black.cgColor
        
        //Restart Button
        restartButton.setImage(UIImage(systemName: "gobackward"), for: .normal)
        restartButton.tintColor = .tabBarItemAccent
        restartButton.imageView?.contentMode = .scaleToFill
        restartButton.imageEdgeInsets = UIEdgeInsets(top: restartButton.frame.width / 1.2,
                                                     left: restartButton.frame.width / 1.2,
                                                     bottom: restartButton.frame.width / 1.2,
                                                     right: restartButton.frame.width / 1.2
        )
        restartButton.layer.cornerRadius = restartButton.frame.width / 2
        restartButton.backgroundColor = .white
        restartButton.layer.borderWidth = 0.2
        restartButton.layer.borderColor = UIColor.systemGray2.withAlphaComponent(1).cgColor
        restartButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        restartButton.layer.shadowRadius = 10
        restartButton.layer.shadowOpacity = 1
        restartButton.layer.shadowColor = UIColor.black.cgColor
    }
}

