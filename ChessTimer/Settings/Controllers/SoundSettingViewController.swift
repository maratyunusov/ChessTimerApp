//
//  AudioSettingsViewController.swift
//  ChessTimer
//
//  Created by Marat Yunusov on 29.03.2023.
//

import UIKit

protocol SoundSettingViewProtocol: AnyObject {
    func updateView()
}

final class SoundSettingViewController: UIViewController, SoundSettingViewProtocol {
    
    private let content: [[String]] = [["Sound", "Time left warning"],["Vibration"]]
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    var presenter: SoundSettingProtocol?
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        presenter = SoundSettingPresenter(view: self)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.backgroundColor = #colorLiteral(red: 1, green: 0.9999999404, blue: 0.9999999404, alpha: 1)
        tableView.register(UINib(nibName: SoundSettingTableViewCell.identifierCell, bundle: nil), forCellReuseIdentifier: SoundSettingTableViewCell.identifierCell)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func updateView() {
        tableView.reloadData()
    }
}

//MARK: - DataSource && Delegate
extension SoundSettingViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return content.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SoundSettingTableViewCell.identifierCell, for: indexPath) as? SoundSettingTableViewCell else { return UITableViewCell()}
        cell.configure(name: content[indexPath.section][indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = [indexPath.section]
        let row = [indexPath.row]
        print(section, row)
        presenter?.didSelectCell(index: 1)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Sounds"
        } else if section == 1 {
            return "Vibration"
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = .tabBarItemAccent
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
