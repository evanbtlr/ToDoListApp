//
//  TodoListRouter.swift
//  ToDoListApp
//
//  Created by Evan Brother on 02.02.2026.
//

import UIKit

// MARK: - Router
final class TodoListRouter {
    
    // MARK: - Properties
    weak var viewController: UIViewController?
}

// MARK: - Router Protocol
extension TodoListRouter: TodoListRouterProtocol {
    func navigateToAddTask() {
        guard let todoListVC = viewController as? TodoListViewController else { return }
        
        let editTodoVC = EditTodoConfigurator.configure(todoListViewController: todoListVC)
        viewController?.navigationController?.pushViewController(editTodoVC, animated: true)
    }
    
    func navigateToEditTask(_ task: TodoTask) {
        guard let todoListVC = viewController as? TodoListViewController else { return }
        
        let editTodoVC = EditTodoConfigurator.configure(for: task, todoListViewController: todoListVC)
        viewController?.navigationController?.pushViewController(editTodoVC, animated: true)
    }
}
