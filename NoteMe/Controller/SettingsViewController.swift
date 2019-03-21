//
//  SettingsViewController.swift
//  NoteMe
//
//  Created by Leonardo Domingues on 3/19/19.
//  Copyright © 2019 Leonardo Domingues. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SettingsViewController: UIViewController {
    
    var managedObjectContext: NSManagedObjectContext?
    
    let settingsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .noteLightGray
        navigationItem.title = "Settings"
        settingsTableView.register(
            SettingCell.self,
            forCellReuseIdentifier: SettingCell.identifier)
        
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        
        settingsTableView.tableFooterView = UIView()
        settingsTableView.separatorStyle = .none
        view.addSubview(settingsTableView)
        activateRegularConstraints()
    }
    
    private func onSettingsOptionSelected() {
        guard let managedContext = managedObjectContext else { return }
        guard let navController = navigationController else { return }
        let categoriesViewController = CategoriesViewController()
        categoriesViewController.managedObjectContext = managedContext
        navController.pushViewController(categoriesViewController, animated: true)
    }
    
    private func activateRegularConstraints() {
        NSLayoutConstraint.activate([
            settingsTableView.topAnchor.constraint(
                equalTo: view.layoutMarginsGuide.topAnchor, constant: 100),
            settingsTableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            settingsTableView.bottomAnchor.constraint(
                equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -100),
            settingsTableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor)
            ])
    }
    
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingCell = tableView.dequeueReusableCell(
            withIdentifier: SettingCell.identifier,
            for: indexPath) as! SettingCell
        settingCell.titleLabel.text = "Categories"
        return settingCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        // TODO: implement for other options
        if indexPath.section == 0 && indexPath.row == 0 { // Categories
            onSettingsOptionSelected()
        }
    }
}


class SettingCell: UITableViewCell {
    
    static let identifier = "com.leodmgs.NoteMe.SettingCell.identifier"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nextImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "next")
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    private func setupCellView() {
        backgroundColor = .white
        addSubview(titleLabel)
        addSubview(nextImageView)
        activateRegularConstraints()
    }
    
    private func activateRegularConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(
                equalTo: self.leadingAnchor, constant: 10),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            nextImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            nextImageView.trailingAnchor.constraint(
                equalTo: self.trailingAnchor, constant: -10),
            nextImageView.widthAnchor.constraint(equalToConstant: 8),
            nextImageView.heightAnchor.constraint(equalToConstant: 16)
            ])
    }
    
}
