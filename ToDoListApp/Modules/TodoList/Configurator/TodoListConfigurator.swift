//
//  TodoListConfigurator.swift
//  ToDoListApp
//
//  Created by Evan Brother on 02.02.2026.
//

import UIKit

// MARK: - Configurator
final class TodoListConfigurator {
    
    static func configure() -> UIViewController {
        return TodoListRouter.createModule()
    }
}
