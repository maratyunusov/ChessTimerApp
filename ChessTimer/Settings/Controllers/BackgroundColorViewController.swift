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
    
    private let didChooseButton: UIButton = {
        let button = UIButton()
        button.setTitle("Choose", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 0.9999999404, blue: 0.9999999404, alpha: 1)
        view.addSubviews(scrollView, pageControl, didChooseButton)
        
        scrollView.delegate = self
        
        didChooseButton.addTarget(self, action: #selector(tapChooseButton), for: .touchUpInside)
        pageControl.addTarget(self, action: #selector(pageControlDidChange), for: .valueChanged)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addConstraints()
        pageControl.currentPage = currentPageStyle
        scrollView.setContentOffset(CGPoint(x: CGFloat(currentPageStyle) * scrollView.frame.size.width, y: 0), animated: false)
    }
    
    //MARK: - Targets
    @objc private func tapChooseButton() {
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
            
            didChooseButton.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 20),
            didChooseButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            didChooseButton.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1/2),
            didChooseButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    
        pageControl.layer.cornerRadius = pageControl.frame.width / 10
        pageControl.numberOfPages = countPageStyle
        
        scrollView.clipsToBounds = false
        
        didChooseButton.backgroundColor = .mainWhite
        didChooseButton.setTitleColor(.tabBarItemAccent, for: .normal)
        didChooseButton.layer.cornerRadius = 50 / 2
        didChooseButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        didChooseButton.layer.shadowRadius = 5
        didChooseButton.layer.shadowOpacity = 0.5
        
        configureScrollView()
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
    }
}
