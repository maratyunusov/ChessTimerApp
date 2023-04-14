//
//  GameModeViewController.swift
//  ChessTimer
//
//  Created by Marat Yunusov on 26.02.2023.
//

import UIKit

final class GameModeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    weak var delegate: MainViewProtocol?
    
    private var activeCellColor: UIColor = .tabBarItemAccent
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
        let model = TimeModel(description: timeModes[indexPath.row].description,
                              time: timeModes[indexPath.row].time)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimeModeCollectionViewCell.cellIdentifier, for: indexPath) as? TimeModeCollectionViewCell else { return UICollectionViewCell()}
        cell.configureCell(model: model)
        if indexPath == lastIndexActive {
            cell.layer.borderColor = activeCellColor.cgColor
            cell.layer.borderWidth = 10
            cell.timeLabel.textColor = .tabBarItemAccent
            cell.minutesTextLabel.textColor = .tabBarItemAccent
            cell.descriptionLabel.textColor = .tabBarItemAccent
        }
        return cell
    }
    
    //MARK: - Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("lastIndexActive - \(lastIndexActive)")
        print(indexPath)
        
        if let time = Double(timeModes[indexPath.row].time) {
            self.time = time * 60
        }
        
        if lastIndexActive != indexPath {
            
            //activeCel
            guard let activeCell = collectionView.cellForItem(at: indexPath) as? TimeModeCollectionViewCell else { return }
            
            activeCell.layer.borderColor = activeCellColor.cgColor
            activeCell.layer.borderWidth = 10
            
            activeCell.timeLabel.textColor = .tabBarItemAccent
            activeCell.minutesTextLabel.textColor = .tabBarItemAccent
            activeCell.descriptionLabel.textColor = .tabBarItemAccent
            
            //inAcitveCell
            guard let inActiveCell = collectionView.cellForItem(at: lastIndexActive) as? TimeModeCollectionViewCell else { return }
            
            inActiveCell.layer.borderColor = #colorLiteral(red: 0.9725490212, green: 0.9725490212, blue: 0.9725490212, alpha: 1).cgColor
            
            inActiveCell.timeLabel.textColor = .tabBarItemAccent
            inActiveCell.minutesTextLabel.textColor = .tabBarItemAccent
            inActiveCell.descriptionLabel.textColor = .tabBarItemAccent
            lastIndexActive = indexPath
        }
    }
}

//MARK: - Extensions
extension GameModeViewController: BackgroundStyleDelegate {
    func changeBackgroundStyle(index: Int) {
        currentPageStyle = index
        changeThemeColor()
        collectionView?.reloadData()
    }
}
