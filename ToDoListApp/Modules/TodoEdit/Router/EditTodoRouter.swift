//
//  EditTodoRouter.swift
//  ToDoListApp
//
//  Created by Evan Brother on 04.02.2026.
//

import UIKit

final class EditTodoRouter {
    
    // MARK: - Properties
    weak var viewController: UIViewController?
    weak var todoListViewController: TodoListViewController?
    
    // MARK: - Private Methods
    private func refreshTodoList() {
        self.todoListViewController?.presenter?.handleViewWillAppear()
    }
}

// MARK: - EditTodoRouterProtocol
extension EditTodoRouter: EditTodoRouterProtocol {
    func closeModule(animated: Bool) {
        self.viewController?.navigationController?.popViewController(animated: animated)
    }
    
    func closeModuleWithRefresh() {
        self.refreshTodoList()
        self.closeModule(animated: true)
    }
}
