//
//  UITableView+DequeueReusableCell.swift
//  ToDoListApp
//
//  Created by Evan Brother on 02.02.2026.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<TCell>(for indexPath: IndexPath) -> TCell where TCell: UITableViewCell {
        return self.dequeueReusableCell(withIdentifier: TCell.identifier(), for: indexPath) as! TCell
    }
    
    func register<TCell>(cell cellType: TCell.Type) where TCell: UITableViewCell {
        self.register(cellType.self, forCellReuseIdentifier: cellType.identifier())
    }
}
