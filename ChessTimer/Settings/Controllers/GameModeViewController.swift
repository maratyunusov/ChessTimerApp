//
//  GameModeViewController.swift
//  ChessTimer
//
//  Created by Marat Yunusov on 26.02.2023.
//

import UIKit

final class GameModeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    weak var delegate: MainViewProtocol?
    
    private var activeCellColor: UIColor = #colorLiteral(red: 0.6642269492, green: 0.6642268896, blue: 0.6642268896, alpha: 1)
    private var currentPageStyle = UserDefaults.standard.integer(forKey: "currentStyle")
    
    private var time: Double = 0.0
    
    private let timeModes: [TimeModel] = [TimeModel(description: "Longer", time: "60"),
                                          TimeModel(description: "Medium", time: "30"),
                                          TimeModel(description: "Standart", time: "15"),
                                          TimeModel(description: "Blitz", time: "10"),
                                          TimeModel(description: "Faster", time: "5"),
                                          TimeModel(description: "Bullet", time: "1")
    ]
    
    private var lastIndexActive: IndexPath = [0,0]
    
    private var collectionView: UICollectionView?
    
    private var swipeDownLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupSwipeDownLabel()
        changeThemeColor()
        
        lastIndexActive.row = UserDefaults.standard.integer(forKey: "indexPathRow")
        time = UserDefaults.standard.double(forKey: "time")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaults.standard.setValue(time, forKey: "time")
        UserDefaults.standard.setValue(lastIndexActive.row, forKey: "indexPathRow")
        delegate?.setChooseTimerMode(time: time)
        
    }
    
    private func changeThemeColor() {
        switch currentPageStyle {
        case 0:
            activeCellColor = ColorSet.classic2
        case 1:
            activeCellColor = ColorSet.styleOne2
        case 2:
            activeCellColor = ColorSet.styleTwo2
        default: break
        }
    }
    
    //MARK: - Configure UI
    
    //setup collection view
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.itemSize = CGSize(width: (view.frame.size.width/2) - 30, height: (view.frame.size.width/2) - 30)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        guard let collectionView = collectionView else { return }
        collectionView.register(UINib(nibName: TimeModeCollectionViewCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: TimeModeCollectionViewCell.cellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.frame = CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: view.frame.height * 0.7))
        collectionView.backgroundColor = #colorLiteral(red: 1, green: 0.9999999404, blue: 0.9999999404, alpha: 1)
        view.backgroundColor = #colorLiteral(red: 1, green: 0.9999999404, blue: 0.9999999404, alpha: 1)
    }
    
    //setup start button
    private func setupSwipeDownLabel() {
        view.addSubview(swipeDownLabel)
        swipeDownLabel.numberOfLines = 0
        swipeDownLabel.font = .systemFont(ofSize: 20, weight: .light)
        swipeDownLabel.textAlignment = .center
        swipeDownLabel.textColor = .tabBarItemAccent
        swipeDownLabel.translatesAutoresizingMaskIntoConstraints = false
        swipeDownLabel.text = "Swipe down to save and close"
        swipeDownLabel.layer.shadowOffset = CGSize(width: 0, height: 5)
        swipeDownLabel.layer.shadowRadius = 5
        swipeDownLabel.layer.shadowOpacity = 0.7
        
        NSLayoutConstraint.activate([
            swipeDownLabel.widthAnchor.constraint(equalToConstant: view.frame.width),
            swipeDownLabel.heightAnchor.constraint(equalToConstant: 50),
            swipeDownLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            swipeDownLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
  
    //MARK: - DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timeModes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimeModeCollectionViewCell.cellIdentifier, for: indexPath) as? TimeModeCollectionViewCell else { return UICollectionViewCell()}
        cell.descriptionLabel.text = timeModes[indexPath.row].description
        cell.timeLabel.text = timeModes[indexPath.row].time
        if indexPath == lastIndexActive {
            cell.backgroundColor = activeCellColor
            cell.timeLabel.textColor = .white
            cell.minutesTextLabel.textColor = .white
            cell.descriptionLabel.textColor = .white
        }
        return cell
    }
    
    //MARK: - Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let time = Double(timeModes[indexPath.row].time) {
            self.time = time * 60
        }
        
        if lastIndexActive != indexPath {
            guard let activeCell = collectionView.cellForItem(at: indexPath) as? TimeModeCollectionViewCell else { return }
            activeCell.backgroundColor = activeCellColor
            activeCell.timeLabel.textColor = .white
            activeCell.minutesTextLabel.textColor = .white
            activeCell.descriptionLabel.textColor = .white
            
            guard let inActiveCell = collectionView.cellForItem(at: lastIndexActive) as? TimeModeCollectionViewCell else { return }
            inActiveCell.backgroundColor = #colorLiteral(red: 1, green: 0.9999999404, blue: 0.9999999404, alpha: 1)
            inActiveCell.timeLabel.textColor = .tabBarItemAccent
            inActiveCell.minutesTextLabel.textColor = .tabBarItemAccent
            inActiveCell.descriptionLabel.textColor = .tabBarItemAccent
            lastIndexActive = indexPath
        }
    }
}
