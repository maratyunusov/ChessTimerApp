//
//  BackgroundColorViewController.swift
//  ChessTimer
//
//  Created by Marat Yunusov on 17.02.2023.
//

import UIKit

protocol BackgroundStyleDelegate: AnyObject {
    func changeBackgroundStyle(index: Int)
}

final class BackgroundColorViewController: UIViewController {
    
    weak var delegateMainVC: BackgroundStyleDelegate?
    weak var delegateSettingVC: BackgroundStyleDelegate?
    weak var delegateGameModeVC: BackgroundStyleDelegate?
    weak var delegateSoundSettingVC: BackgroundStyleDelegate?
    
    private var currentPageStyle = UserDefaults.standard.integer(forKey: "currentStyle")
    private let countPageStyle: Int = 3
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private var swipeDownLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 0.9999999404, blue: 0.9999999404, alpha: 1)
        view.addSubviews(scrollView, pageControl, swipeDownLabel)
        addConstraints()
        
        scrollView.delegate = self
        
        pageControl.addTarget(self, action: #selector(pageControlDidChange), for: .valueChanged)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureScrollView()
        scrollView.setContentOffset(CGPoint(x: CGFloat(currentPageStyle) * scrollView.frame.size.width, y: 0), animated: false)
        pageControl.currentPage = currentPageStyle
    }
    
    //MARK: - Targets
    @objc private func pageControlDidChange(_ sender: UIPageControl) {
        let current = sender.currentPage
        scrollView.setContentOffset(CGPoint(x: CGFloat(current) * scrollView.frame.size.width, y: 0), animated: true)
    }
    
    //MARK: - Setup Constraints
    private func addConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            scrollView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.65),
            
            pageControl.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 5),
            pageControl.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            pageControl.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3),
            
            swipeDownLabel.widthAnchor.constraint(equalToConstant: view.frame.width),
            swipeDownLabel.heightAnchor.constraint(equalToConstant: 50),
            swipeDownLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            swipeDownLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    
        pageControl.layer.cornerRadius = pageControl.frame.width / 10
        pageControl.numberOfPages = countPageStyle
        
        pageControl.layer.shadowOffset = CGSize(width: 0, height: 0)
        pageControl.layer.shadowRadius = 1
        pageControl.layer.shadowOpacity = 3
        
        swipeDownLabel.numberOfLines = 0
        swipeDownLabel.font = .systemFont(ofSize: 20, weight: .light)
        swipeDownLabel.textAlignment = .center
        swipeDownLabel.textColor = .tabBarItemAccent
        swipeDownLabel.translatesAutoresizingMaskIntoConstraints = false
        swipeDownLabel.text = "Swipe down to save and close"
        swipeDownLabel.layer.shadowOffset = CGSize(width: 0, height: 5)
        swipeDownLabel.layer.shadowRadius = 5
        swipeDownLabel.layer.shadowOpacity = 0.7
        
        scrollView.clipsToBounds = false
    }
    
    private func configureScrollView() {
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(countPageStyle),
                                        height: scrollView.frame.size.height
        )
        scrollView.isPagingEnabled = true
        for x in 0..<countPageStyle {
            let page = UIImageView(frame: CGRect(x: CGFloat(x) * scrollView.frame.width,
                                            y: 0,
                                            width: scrollView.frame.size.width,
                                            height: scrollView.frame.size.height)
            )
            page.image = UIImage(named: "style\(x)")
            page.contentMode = .scaleAspectFit
            scrollView.addSubview(page)
        }
    }
}

//MARK: - EXTENSIONS
extension BackgroundColorViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(floorf(Float(scrollView.contentOffset.x) / Float(scrollView.frame.size.width)))
        UserDefaults.standard.set(pageControl.currentPage, forKey: "currentStyle")
        
        delegateMainVC?.changeBackgroundStyle(index: pageControl.currentPage)
        delegateSettingVC?.changeBackgroundStyle(index: pageControl.currentPage)
        delegateGameModeVC?.changeBackgroundStyle(index: pageControl.currentPage)
        delegateSoundSettingVC?.changeBackgroundStyle(index: pageControl.currentPage)
    }
}
