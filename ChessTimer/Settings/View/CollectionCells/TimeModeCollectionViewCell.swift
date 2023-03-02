//
//  TimeModeCollectionViewCell.swift
//  ChessTimer
//
//  Created by Marat Yunusov on 26.02.2023.
//

import UIKit

final class TimeModeCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "TimeModeCollectionViewCell"
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var minutesTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = frame.width / 15
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.5
        
        descriptionLabel.textColor = .tabBarItemAccent
        timeLabel.textColor = .tabBarItemAccent
        minutesTextLabel.textColor = .tabBarItemAccent
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        descriptionLabel.textColor = .tabBarItemAccent
//        timeLabel.textColor = .tabBarItemAccent
//        minutesTextLabel.textColor = .tabBarItemAccent
    }
    
}
