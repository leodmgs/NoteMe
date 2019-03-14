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

    var coreDataBroker: CoreDataBroker = {
        let coreData = CoreDataBroker(modelName: "NoteMe")
        return coreData
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let entityDesc = NSEntityDescription.entity(forEntityName: "Note", in: self.coreDataBroker.managedObjectContext) {
            print(entityDesc.name ?? "No name")
            print(entityDesc.description)
            let note = NSManagedObject(entity: entityDesc, insertInto: self.coreDataBroker.managedObjectContext)
            note.setValue("This is the fucking first Note!", forKey: "title")
            note.setValue(NSDate(), forKey: "createdAt")
            note.setValue(NSDate(), forKey: "updatedAt")
            print(note)
            do {
                try self.coreDataBroker.managedObjectContext.save()
            } catch {
                print("Unable to save managed object context")
                print("\(error), \(error.localizedDescription)")
            }
        }
        setupView()
    }

    private func setupView() {
        DispatchQueue.main.async {
            self.view.backgroundColor = .white
        }
    }

}

