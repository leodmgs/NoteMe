//
//  NoteMe+UIButton.swift
//  NoteMe
//
//  Created by Leonardo Domingues on 3/21/19.
//  Copyright © 2019 Leonardo Domingues. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func press() {
        let press = CABasicAnimation(keyPath: "transform.scale")
        press.duration = 0.5
        press.toValue = 0.85
        press.speed = 5
        press.autoreverses = true
        layer.add(press, forKey: nil)
    }
}
