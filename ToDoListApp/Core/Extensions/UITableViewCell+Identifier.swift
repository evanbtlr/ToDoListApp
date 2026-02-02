//
//  UITableViewCell+Identifier.swift
//  ToDoListApp
//
//  Created by Evan Brother on 02.02.2026.
//

import UIKit

extension UITableViewCell {
    class func identifier() -> String {
        String(describing: Self.self)
    }
}
