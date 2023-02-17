//
//  MainViewPresenter.swift
//  ChessTimer
//
//  Created by Marat Yunusov on 12.02.2023.
//

import Foundation

protocol MainViewPresenterProtocol: AnyObject {
    
}

final class MainViewPresenter: MainViewPresenterProtocol {
    
    weak var mainView: MainViewProtocol?
    
    init(mainView: MainViewProtocol?) {
        self.mainView = mainView
    }
}
