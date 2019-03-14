//
//  ViewController.swift
//  NoteMe
//
//  Created by Leonardo Domingues on 3/7/19.
//  Copyright © 2019 Leonardo Domingues. All rights reserved.
//

import UIKit
import CoreData

class NoteViewController: UIViewController {

    private var notes: [Note]? {
        didSet {
            notesDidChange()
        }
    }
    
    var coreDataBroker: CoreDataBroker = {
        let coreData = CoreDataBroker(modelName: "NoteMe")
        return coreData
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchNotes()
    }
    
    private func setupNavigationBar() {
        guard let navController = navigationController else { return }
        navController.navigationBar.isTranslucent = false
        navController.navigationBar.topItem?.title = "NoteMe"
        let addNoteButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add, target: self, action: #selector(onAddNoteTapped))
        navigationItem.rightBarButtonItem = addNoteButtonItem
    }
    
    @objc private func onAddNoteTapped() {
        guard let navController = navigationController else { return }
        let addNoteViewController = AddNoteViewController()
        addNoteViewController.managedObjectContext = coreDataBroker.managedObjectContext
        navController.pushViewController(addNoteViewController, animated: true)
    }

    private func setupView() {
        DispatchQueue.main.async {
            self.view.backgroundColor = .white
        }
    }
    
    private func notesDidChange() {
//        printAllNotesToConsole()
    }
    
    func printAllNotesToConsole() {
        if let notes = self.notes {
            for note in notes {
                print(note.title!)
            }
        }
    }
    
    private func fetchNotes() {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(
            key: #keyPath(Note.updatedAt), ascending: false)]
        coreDataBroker.managedObjectContext.performAndWait {
            do {
                let notes = try fetchRequest.execute()
                self.notes = notes
                printAllNotesToConsole()
            } catch {
                let fetchError = error as NSError
                print("Unable to Execute Fetch Request")
                print("\(fetchError), \(fetchError.localizedDescription)")
            }
        }
    }

}

