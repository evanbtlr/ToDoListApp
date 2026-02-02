//
//  TodoCell.swift
//  ToDoListApp
//
//  Created by Evan Brother on 02.02.2026.
//

import UIKit

// MARK: - Cell
final class TodoCell: UITableViewCell {
    
    // MARK: UI Components
    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var completedSwitch: UISwitch!
    
    // MARK: Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupUI()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    private func setupUI() {
        let titleLabel = UILabel()
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.numberOfLines = 0
        
        self.titleLabel = titleLabel
        self.addSubview(titleLabel)
        
        let descriptionLabel = UILabel()
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 0
        
        self.descriptionLabel = descriptionLabel
        self.addSubview(descriptionLabel)
        
        let completedSwitch = UISwitch()
        
        completedSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        self.completedSwitch = completedSwitch
        self.addSubview(completedSwitch)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: completedSwitch.leadingAnchor, constant: -8),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: completedSwitch.leadingAnchor, constant: -8),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            completedSwitch.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            completedSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            completedSwitch.widthAnchor.constraint(equalToConstant: 51)
        ])
    }
    
    // MARK: Configuration
    func configurate(with task: TodoTask) {
        self.descriptionLabel.text = task.description
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
}


