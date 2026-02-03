//
//  TodoCell.swift
//  ToDoListApp
//
//  Created by Evan Brother on 02.02.2026.
//

import UIKit

// MARK: - Cell
final class TodoCell: UITableViewCell {
    
    // MARK: Properties
    var onToggle: ((Bool) -> Void)?
    
    // MARK: UI Components
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var completedSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.completedSwitch.addTarget(self, action: #selector(switchToggled), for: .valueChanged)
    }
    
    // MARK: Configuration
    func configurate(with task: TodoTask) {
        self.descriptionLabel.text = task.description ?? ""
        self.completedSwitch.isOn = task.isCompleted

        if task.isCompleted {
            let attributedString = NSAttributedString(string: task.title, attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
            
            self.titleLabel.attributedText = attributedString
            self.titleLabel.textColor = .secondaryLabel
        } else {
            self.titleLabel.attributedText = nil
            self.titleLabel.text = task.title
            self.titleLabel.textColor = .label
        }
    }
    
    // MARK: Actions
    @objc private func switchToggled(_ sender: UISwitch) {
        onToggle?(sender.isOn)
    }
}


