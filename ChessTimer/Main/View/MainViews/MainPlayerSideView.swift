//
//  PlayerSideView.swift
//  ChessTimer
//
//  Created by Marat Yunusov on 11.02.2023.
//

import UIKit

protocol MainPlayerSideViewProtocol: AnyObject {
    
}

/// UIView, watch side for player
final class MainPlayerSideView: UIView, MainPlayerSideViewProtocol {
    enum TrasformView {
        case normal
        case left
        case right
        case reverse
    }
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "5:00"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    public let tapStartLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tap to Start"
        return label
    }()
    
    let setupTimeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let timerPickerView: TimerSetupView = {
        let timePicker = TimerSetupView()
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        return timePicker
    }()
    
    private let stackViewChoosesButtons: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("SAVE", for: .normal)
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("CANCEL", for: .normal)
        return button
    }()
    
    private let titlePickerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    init(transformSideView: TrasformView?) {
        super.init(frame: .zero)
        
        switch transformSideView {
        case .left:
            transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        case .right:
            transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        case .reverse:
            transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        default:
            return
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubviews(timerLabel, setupTimeButton, timerPickerView, stackViewChoosesButtons, titlePickerStackView, tapStartLabel)
        
        timerPickerView.isHidden = true
        titlePickerStackView.isHidden = true
        
        addConstraints()
        setupStackView()
        setupTitlePickerStackView()
        
        setFontForLabel(label: timerLabel, maxFontSize: 100, minFontSize: 5, maxLines: 2)
        setFontForLabel(label: tapStartLabel, maxFontSize: 100, minFontSize: 5, maxLines: 1)
        
        setupTimeButton.addTarget(self, action: #selector(setupTime), for: .touchUpInside)
        saveButton.addTarget( self, action: #selector(saveTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        
    }
    
    @objc private func setupTime() {
        timerLabel.isHidden = true
        tapStartLabel.isHidden = true
        timerPickerView.isHidden = false
        stackViewChoosesButtons.isHidden = false
        setupTimeButton.isHidden = true
        titlePickerStackView.isHidden = false
    }
    
    @objc private func saveTapped() {
        if Int(timerPickerView.timerTuple.0)! == 0 {
            timerLabel.text = timerPickerView.timerTuple.1 + ":" + timerPickerView.timerTuple.2
        } else if Int(timerPickerView.timerTuple.0)! < 10 {
            timerLabel.text = timerPickerView.timerTuple.0 + ":" + timerPickerView.timerTuple.1 + ":" + timerPickerView.timerTuple.2
        } else {
            timerLabel.text = timerPickerView.timerTuple.0 + ":" + timerPickerView.timerTuple.1 + ":" + timerPickerView.timerTuple.2
        }
        
        setupTimeButton.isHidden = false
        timerLabel.isHidden = false
        tapStartLabel.isHidden = false
        timerPickerView.isHidden = true
        stackViewChoosesButtons.isHidden = true
        titlePickerStackView.isHidden = true
    }
    
    @objc private func cancelTapped() {
        setupTimeButton.isHidden = false
        timerLabel.isHidden = false
        tapStartLabel.isHidden = false
        timerPickerView.isHidden = true
        stackViewChoosesButtons.isHidden = true
        titlePickerStackView.isHidden = true
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            timerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            timerLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/2),
            timerLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/4),
            
            tapStartLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            tapStartLabel.bottomAnchor.constraint(equalTo: timerLabel.topAnchor, constant: -20),
            tapStartLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/2),
            tapStartLabel.heightAnchor.constraint(equalToConstant: 25),
            
            timerPickerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            timerPickerView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            timerPickerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1),
            timerPickerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/2),
            
            setupTimeButton.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 20),
            setupTimeButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            setupTimeButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/12),
            setupTimeButton.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1/12),
            
            stackViewChoosesButtons.topAnchor.constraint(equalTo: timerPickerView.bottomAnchor, constant: 10),
            stackViewChoosesButtons.leftAnchor.constraint(equalTo: leftAnchor, constant: 30),
            stackViewChoosesButtons.rightAnchor.constraint(equalTo: rightAnchor, constant: -30),
            stackViewChoosesButtons.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            
            titlePickerStackView.topAnchor.constraint(equalTo: timerPickerView.bottomAnchor, constant: -10),
            titlePickerStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            titlePickerStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1),
            titlePickerStackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/15)
        ])
    }
    
    private func setupStackView() {
        stackViewChoosesButtons.isHidden = true
        stackViewChoosesButtons.addArrangedSubview(saveButton)
        stackViewChoosesButtons.addArrangedSubview(cancelButton)
    }
    
    private func setupTitlePickerStackView() {
        for (index, _) in (0...2).enumerated() {
            let namePicker = UILabel()
            if index == 0 {
                namePicker.text = "hours"
            } else if index == 1 {
                namePicker.text = "minutes"
            } else if index == 2 {
                namePicker.text = "seconds"
            }
            namePicker.textAlignment = .center
            namePicker.textColor = .white
            namePicker.translatesAutoresizingMaskIntoConstraints = false
            titlePickerStackView.addArrangedSubview(namePicker)
        }
    }
}

extension MainPlayerSideView {
    
    /// Dynamic text font size in label
    private func setFontForLabel(label:UILabel, maxFontSize:CGFloat, minFontSize:CGFloat, maxLines:Int) {
        var numLines: Int = 1
        var textSize: CGSize = CGSize.zero
        var frameSize: CGSize = CGSize.zero
        let font: UIFont = label.font.withSize(maxFontSize)

        frameSize = label.frame.size

        textSize = (label.text! as NSString).size(withAttributes: [NSAttributedString.Key.font: font])

        // Determine number of lines
        while ((textSize.width/CGFloat(numLines)) / (textSize.height * CGFloat(numLines)) > frameSize.width / frameSize.height) && numLines < maxLines {
            numLines += 1
        }

        label.font = font
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = numLines
        label.minimumScaleFactor = minFontSize/maxFontSize
    }
}
