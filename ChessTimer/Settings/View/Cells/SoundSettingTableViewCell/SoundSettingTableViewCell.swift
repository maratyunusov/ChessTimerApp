//
//  SoundSettingTableViewCell.swift
//  ChessTimer
//
//  Created by Marat Yunusov on 29.03.2023.
//

import UIKit

class SoundSettingTableViewCell: UITableViewCell {
    
    static let identifierCell = "SoundSettingTableViewCell"
    private var currentPageStyle: Int?

    @IBOutlet weak var nameLabel: UILabel!
    //@IBOutlet weak var switchMode: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.font = .systemFont(ofSize: 25, weight: .light)
        //switchMode.addTarget(self, action: #selector(switchModed), for: .valueChanged)
    }
    
    //MARK: - Layout subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        currentPageStyle = UserDefaults.standard.integer(forKey: "currentStyle")
        setupColor()
    }
    
//    @objc func switchModed(sender: UISwitch) {
//        
//        print(sender.isOn)
//    }
    
    func configure(name: String) {
        nameLabel.text = name
    }
    
    private func setupColor() {
        switch currentPageStyle {
        case 0:
            backgroundColor = ColorSet.classic2
        case 1:
            backgroundColor = ColorSet.styleOne2
        case 2:
            backgroundColor = ColorSet.styleTwo2
        default: break
        }
    }
}
