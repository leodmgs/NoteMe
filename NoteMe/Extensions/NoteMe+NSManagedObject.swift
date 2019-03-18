//
//  NoteMe+NSManagedObject.swift
//  NoteMe
//
//  Created by Leonardo Domingues on 3/18/19.
//  Copyright © 2019 Leonardo Domingues. All rights reserved.
//

import Foundation
import CoreData

public extension NSManagedObject {
    
    convenience init(context: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: context)!
        self.init(entity: entity, insertInto: context)
    }
    
}
