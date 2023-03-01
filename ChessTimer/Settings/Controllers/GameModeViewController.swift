//
//  GameModeViewController.swift
//  ChessTimer
//
//  Created by Marat Yunusov on 26.02.2023.
//

import UIKit

final class GameModeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    weak var delegate: MainViewProtocol?
    
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
    
    private var startButton: UIButton = {
        let button = UIButton()
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupStartButton()
        
        lastIndexActive.row = UserDefaults.standard.integer(forKey: "indexPathRow")
        time = UserDefaults.standard.double(forKey: "time")
        startButton.addTarget(self, action: #selector(tapStart), for: .touchUpInside)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("disappear")
        UserDefaults.standard.setValue(time, forKey: "time")
        UserDefaults.standard.setValue(lastIndexActive.row, forKey: "indexPathRow")
    }
    
    //MARK: - Targets
    @objc func tapStart() {
        delegate?.setChooseTimerMode(time: time)
        dismiss(animated: true)
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
        collectionView.backgroundColor = #colorLiteral(red: 0.8374214172, green: 0.8374213576, blue: 0.8374213576, alpha: 1)
        view.backgroundColor = #colorLiteral(red: 0.8374214172, green: 0.8374213576, blue: 0.8374213576, alpha: 1)
    }
    
    //setup start button
    private func setupStartButton() {
        view.addSubview(startButton)
        startButton.setTitle("START", for: .normal)
        startButton.setTitleColor(.tabBarItemAccent, for: .normal)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.backgroundColor = .mainWhite
        startButton.layer.cornerRadius = 50 / 2
        startButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        startButton.layer.shadowRadius = 5
        startButton.layer.shadowOpacity = 0.5
        
        NSLayoutConstraint.activate([
            startButton.widthAnchor.constraint(equalToConstant: view.frame.width / 3),
            startButton.heightAnchor.constraint(equalToConstant: 50),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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
            cell.backgroundColor = #colorLiteral(red: 0.482352972, green: 0.482352972, blue: 0.482352972, alpha: 1)
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
            activeCell.backgroundColor = #colorLiteral(red: 0.482352972, green: 0.482352972, blue: 0.482352972, alpha: 1)
            activeCell.layer.masksToBounds = true
            
            guard let inActiveCell = collectionView.cellForItem(at: lastIndexActive) as? TimeModeCollectionViewCell else { return }
            inActiveCell.backgroundColor = #colorLiteral(red: 0.6627451181, green: 0.6627451181, blue: 0.6627451181, alpha: 1)
            inActiveCell.layer.masksToBounds = false
            lastIndexActive = indexPath
        }
    }
}
