//
//  AudioSettingsViewController.swift
//  ChessTimer
//
//  Created by Marat Yunusov on 29.03.2023.
//

import UIKit

protocol SoundSettingViewProtocol: AnyObject {
    func updateView(content: [[String: Bool]])
}

final class SoundSettingViewController: UIViewController, SoundSettingViewProtocol {
    
    private var content: [[String: Bool]] = []
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private var presenter: SoundSettingProtocol?
    
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
    
    func updateView(content: [[String : Bool]]) {
        self.content = content
        //tableView.reloadData()
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SoundSettingTableViewCell.identifierCell, for: indexPath) as? SoundSettingTableViewCell else { return UITableViewCell() }
        let array = Array(content[indexPath.section]).sorted { $0.key < $1.key }
        
        cell.configure(name: array[indexPath.row].key)
        
        let switchView = UISwitch(frame: .zero)
        switchView.setOn(array[indexPath.row].value, animated: true)
        switchView.tag = indexPath.row
        switchView.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        
        cell.accessoryView = switchView
        
        return cell
    }
    
    @objc func switchChanged(_ sender: UISwitch) {
        if sender.tag == 0 {
            sender.isOn ? presenter?.soundMode(isOn: true) : presenter?.soundMode(isOn: false)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "SOUND"
        case 1: return "TAPTIC"
        default: break
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.font = .systemFont(ofSize: 20, weight: .light)
            header.textLabel?.textColor = .tabBarItemAccent
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        presenter?.didSelectCell(section: section, row: row)
    }
}

//MARK: - Extensions
extension SoundSettingViewController: BackgroundStyleDelegate {
    func changeBackgroundStyle(index: Int) {
        tableView.reloadData()
    }
}
