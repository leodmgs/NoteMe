//
//  CategoryItem+NSAttributedString.swift
//  NoteMe
//
//  Created by Leonardo Domingues on 3/29/19.
//  Copyright © 2019 Leonardo Domingues. All rights reserved.
//

import Foundation
import UIKit

extension NSAttributedString {
    static func categoryItemAttributed(forText text: String) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)])
    }
}
