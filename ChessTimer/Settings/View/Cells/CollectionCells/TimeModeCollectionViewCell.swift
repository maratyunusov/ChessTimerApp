//
//  TimeModeCollectionViewCell.swift
//  ChessTimer
//
//  Created by Marat Yunusov on 26.02.2023.
//

import UIKit

final class TimeModeCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "TimeModeCollectionViewCell"
    var activeCellColor: UIColor?
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var minutesTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = frame.width / 4
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.5
        
        descriptionLabel.textColor = .tabBarItemAccent
        timeLabel.textColor = .tabBarItemAccent
        minutesTextLabel.textColor = .tabBarItemAccent
    }
    
    public func configureCell(model: TimeModel) {
        descriptionLabel.text = model.description
        timeLabel.text = model.time
    }
    
    private func setupBackGroundColor() {
        let index = UserDefaults.standard.integer(forKey: "currentStyle") 
        switch index {
        case 0:
            activeCellColor = ColorSet.classic2
        case 1:
            activeCellColor = ColorSet.styleOne2
        case 2:
            activeCellColor = ColorSet.styleTwo2
        default: break
        }
    }
}
