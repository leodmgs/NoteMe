//
//  AddNoteViewController.swift
//  NoteMe
//
//  Created by Leonardo Domingues on 3/14/19.
//  Copyright © 2019 Leonardo Domingues. All rights reserved.
//

import Foundation
import UIKit

class AddNoteViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        setupNavigationBar()
        DispatchQueue.main.async {
            self.view.backgroundColor = .white
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Add Note"
        let backButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(onBackTapped))
        navigationItem.leftBarButtonItem = backButtonItem
    }
    
    @objc private func onBackTapped() {
        _ = navigationController?.popViewController(animated: true)
    }
    
}
