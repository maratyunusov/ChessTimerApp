//
//  GameModeViewController.swift
//  ChessTimer
//
//  Created by Marat Yunusov on 26.02.2023.
//

import UIKit

class GameModeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var time: Double = 0.0
    
    private var collectionView: UICollectionView?
    
    private let timeModes: [TimeModel] = [TimeModel(description: "Longer", time: "60"),
                                  TimeModel(description: "Medium", time: "30"),
                                  TimeModel(description: "Standart", time: "15"),
                                  TimeModel(description: "Blitz", time: "10"),
                                  TimeModel(description: "Faster", time: "5"),
                                  TimeModel(description: "Bullet", time: "1")
    ]
    
    private var lastIndexActive: IndexPath = [0,4]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.itemSize = CGSize(width: (view.frame.size.width/2) - 30, height: (view.frame.size.width/2) - 30)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        guard let collectionView = collectionView else { return }
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(UINib(nibName: TimeModeCollectionViewCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: TimeModeCollectionViewCell.cellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        collectionView.backgroundColor = #colorLiteral(red: 0.8374214172, green: 0.8374213576, blue: 0.8374213576, alpha: 1)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("disapear - \(time)")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timeModes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimeModeCollectionViewCell.cellIdentifier, for: indexPath) as? TimeModeCollectionViewCell else { return UICollectionViewCell()}
        cell.descriptionLabel.text = timeModes[indexPath.row].description
        cell.timeLabel.text = timeModes[indexPath.row].time
        if indexPath == lastIndexActive {
            cell.backgroundColor = #colorLiteral(red: 0.482352972, green: 0.482352972, blue: 0.482352972, alpha: 1)
        }
        return cell
    }
    
    /// Selected function delegate collection view
    /// - Parameters:
    ///   - collectionView: Time modes collection view
    ///   - indexPath: Index path
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let time = Double(timeModes[indexPath.row].time) {
            self.time = time * 60
        }
        
        if lastIndexActive != indexPath {
            guard let activeCell = collectionView.cellForItem(at: indexPath) as? TimeModeCollectionViewCell else { return }
            activeCell.backgroundColor = #colorLiteral(red: 0.482352972, green: 0.482352972, blue: 0.482352972, alpha: 1)
            activeCell.layer.masksToBounds = true
            
            guard let inActiveCell = collectionView.cellForItem(at: lastIndexActive) as? TimeModeCollectionViewCell else { return }
            inActiveCell.backgroundColor = #colorLiteral(red: 0.6627451181, green: 0.6627451181, blue: 0.6627451181, alpha: 1)
            inActiveCell.layer.masksToBounds = true
            lastIndexActive = indexPath
        }
    }
}
