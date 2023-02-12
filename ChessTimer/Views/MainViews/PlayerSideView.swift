//
//  PlayerSideView.swift
//  ChessTimer
//
//  Created by Marat Yunusov on 11.02.2023.
//

import UIKit

/// UIView, watch side for player
final class PlayerSideView: UIView {
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
        addSubview(timerLabel)
        addSubview(setupTimeButton)
        addSubview(timerPickerView)
        
        timerPickerView.isHidden = true
        
        addConstraints()
        setFontForLabel(label: timerLabel, maxFontSize: 100, minFontSize: 5, maxLines: 2)
        setupTimeButton.addTarget(self, action: #selector(setupTime), for: .touchUpInside)
    }
    
    @objc private func setupTime() {
        timerPickerView.isHidden = false
        timerLabel.isHidden = true
        setupTimeButton.isHidden = true
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            timerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            timerLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/2),
            timerLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/4),
            
            timerPickerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            timerPickerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            timerPickerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1),
            timerPickerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/2),
            
            setupTimeButton.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 20),
            setupTimeButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            setupTimeButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/12),
            setupTimeButton.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1/12)
        ])
    }
}

extension PlayerSideView {
    
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
