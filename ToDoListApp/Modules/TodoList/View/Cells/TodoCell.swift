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
    var title: String = String()
    var onToggle: ((Bool) -> Void)?
    
    // MARK: UI Components
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var completedSwitch: UISwitch!
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupActions()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.onToggle = nil
        self.title = .init()
        
        self.titleLabel.attributedText = nil
        self.titleLabel.text = nil
        
        self.descriptionLabel.text = nil
        self.dateLabel.text = nil
        
        completedSwitch.isOn = false
    }
    
    // MARK: Setup
    private func setupActions() {
        self.completedSwitch.addTarget(self, action: #selector(switchToggled), for: .valueChanged)
    }
    
    // MARK: Configuration
    func configurate(with task: TodoTask) {
        self.title = task.title
        
        self.descriptionLabel.text = task.description ?? ""
        self.dateLabel.text = task.createdAt.formatted(date: .numeric, time: .omitted)
        self.completedSwitch.isOn = task.isCompleted

        self.updateUIForCompletion(task.isCompleted)
    }
    
    // MARK: Actions
    @objc private func switchToggled(_ sender: UISwitch) {
        onToggle?(sender.isOn)
        
        self.updateUIForCompletion(sender.isOn)
    }
    
    // MARK: Helpers
    private func updateUIForCompletion(_ isCompleted: Bool) {
        guard isCompleted else {
            self.titleLabel.attributedText = nil
            self.titleLabel.text = self.title
            self.titleLabel.textColor = .label
            
            self.descriptionLabel.textColor = .secondaryLabel
            self.dateLabel.textColor = .secondaryLabel
            return
        }
        
        let attributedString = NSAttributedString(string: self.title, attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
        
        self.titleLabel.attributedText = attributedString
        self.titleLabel.textColor = .secondaryLabel
        
        self.descriptionLabel.textColor = .tertiaryLabel
        self.dateLabel.textColor = .tertiaryLabel
    }
}


