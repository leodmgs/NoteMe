//
//  CategoryColorView.swift
//  NoteMe
//
//  Created by Leonardo Domingues on 3/20/19.
//  Copyright © 2019 Leonardo Domingues. All rights reserved.
//

import Foundation
import UIKit

protocol CategoryColorViewDelegate {
    func categoryColorDidSelected(color: UIColor, colorId: Int)
}

class CategoryColorView: UIView {
    
    var delegate: CategoryColorViewDelegate?
    
    private let colorStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    private var colors: [UIView]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupColorViews()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    private func setupColorViews() {
        let blue = createColorView(colorId: CategoryColor.Id.blue)
        let green = createColorView(colorId: CategoryColor.Id.green)
        let red = createColorView(colorId: CategoryColor.Id.red)
        let orange = createColorView(colorId: CategoryColor.Id.orange)
        let magenta = createColorView(colorId: CategoryColor.Id.magenta)
        colorStackView.addArrangedSubview(blue)
        colorStackView.addArrangedSubview(orange)
        colorStackView.addArrangedSubview(green)
        colorStackView.addArrangedSubview(red)
        colorStackView.addArrangedSubview(magenta)
    }
    
    private func createColorView(colorId: Int) -> UIButton {
        let colorButtonView: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.layer.cornerRadius = 28
            button.clipsToBounds = true
            button.backgroundColor = CategoryColor.getColor(id: colorId)
            button.tag = colorId
            return button
        }()
        colorButtonView.addTarget(
            self, action: #selector(onColorSelected), for: .touchUpInside)
        return colorButtonView
    }
    
    @objc private func onColorSelected(sender: UIButton) {
        sender.press()
        guard let delegate = delegate else { return }
        let color = CategoryColor.getColor(id: sender.tag)
        delegate.categoryColorDidSelected(
            color: color, colorId: sender.tag)
    }
    
    private func setupView() {
        addSubview(colorStackView)
        setupRegularConstraints()
    }
    
    private func setupRegularConstraints() {
        NSLayoutConstraint.activate([
            colorStackView.topAnchor.constraint(equalTo: self.topAnchor),
            colorStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            colorStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            colorStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
    }
    
}

struct CategoryColor {
    
    struct Id {
        static let blue: Int = 0
        static let orange: Int = 1
        static let green: Int = 2
        static let red: Int = 3
        static let magenta: Int = 4
        static let lightGray: Int = 5
    }
    
    static let count: Int = 5
    
    static func getColor(id: Int) -> UIColor {
        switch id {
        case self.Id.blue:
            return self.blue
        case self.Id.orange:
            return self.orange
        case self.Id.green:
            return self.green
        case self.Id.red:
            return self.red
        case self.Id.magenta:
            return self.magenta
        case self.Id.lightGray:
            return self.lightGray
        default:
            return UIColor.white
        }
    }
    
    static var blue: UIColor {
        get {
            return UIColor(red: 0.43, green: 0.61, blue: 0.86, alpha: 1.0)
        }
    }
    
    static var orange: UIColor {
        get {
            return UIColor(red: 1.0, green: 0.69, blue: 0.25, alpha: 1.0)
        }
    }
    
    static var green: UIColor {
        get {
            return UIColor(red: 0.49, green: 0.77, blue: 0.49, alpha: 1.0)
        }
    }
    
    static var red: UIColor {
        get {
            return UIColor(red: 0.91, green: 0.43, blue: 0.43, alpha: 1.0)
        }
    }
    
    static var magenta: UIColor {
        get {
            return UIColor(red: 0.77, green: 0.56, blue: 0.82, alpha: 1.0)
        }
    }
    
    static var lightGray: UIColor {
        get {
            return UIColor(red: 0.92, green: 0.92, blue: 0.93, alpha: 1.0)
        }
    }
    
}
