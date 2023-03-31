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
    
    weak var delegate: BackgroundStyleDelegate?
    private var currentPageStyle = UserDefaults.standard.integer(forKey: "currentStyle")
    private let countPageStyle: Int = 3
    
    let notificationCenter = NotificationCenter.default
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.backgroundColor = #colorLiteral(red: 0.6627451181, green: 0.6627451181, blue: 0.6627451181, alpha: 1)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private let didSaveButton: UIButton = {
        let button = UIButton()
        button.setTitle("SAVE", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 0.9999999404, blue: 0.9999999404, alpha: 1)
        view.addSubviews(scrollView, pageControl, didSaveButton)
        
        scrollView.delegate = self
        
        didSaveButton.addTarget(self, action: #selector(tapSaveButton), for: .touchUpInside)
        pageControl.addTarget(self, action: #selector(pageControlDidChange), for: .valueChanged)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addConstraints()
        pageControl.currentPage = currentPageStyle
        scrollView.setContentOffset(CGPoint(x: CGFloat(currentPageStyle) * scrollView.frame.size.width, y: 0), animated: false)
    }
    
    //MARK: - Targets
    @objc private func tapSaveButton() {
        delegate?.changeBackgroundStyle(index: pageControl.currentPage)
        UserDefaults.standard.set(pageControl.currentPage, forKey: "currentStyle")
        dismiss(animated: true)
    }
    
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
            scrollView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.7),
            
            pageControl.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 20),
            pageControl.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            pageControl.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1/3),
            
            didSaveButton.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 20),
            didSaveButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            didSaveButton.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1/2),
            didSaveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    
        pageControl.layer.cornerRadius = pageControl.frame.width / 10
        pageControl.numberOfPages = countPageStyle
        
        scrollView.clipsToBounds = false
        
        didSaveButton.setTitleColor(.white, for: .normal)
        didSaveButton.layer.cornerRadius = 50 / 2
        didSaveButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        didSaveButton.layer.shadowRadius = 5
        didSaveButton.layer.shadowOpacity = 0.5
        
        configureScrollView()
        
        setupColor()
    }
    
    private func setupColor() {
        switch currentPageStyle {
        case 0:
            pageControl.backgroundColor = ColorSet.classic2
            didSaveButton.backgroundColor = ColorSet.classic2
        case 1:
            pageControl.backgroundColor = ColorSet.styleOne2
            didSaveButton.backgroundColor = ColorSet.styleOne2
        case 2:
            pageControl.backgroundColor = ColorSet.styleTwo2
            didSaveButton.backgroundColor = ColorSet.styleTwo2
        default: break
        }
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
        //notificationCenter.post(name: .changeThemeColorNotification, object: self, userInfo: ["index": pageControl.currentPage])
        //setupColor()
    }
}
