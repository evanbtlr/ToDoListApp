//
//  EditTodoConfigurator.swift
//  ToDoListApp
//
//  Created by Evan Brother on 04.02.2026.
//

import UIKit

final class EditTodoConfigurator {
    
    static func configure(for task: TodoTask? = nil, todoListViewController: TodoListViewController? = nil) -> UIViewController {
        let data = task.map { EditTodoData(from: $0) } ?? EditTodoData()
        
        let view = EditTodoViewController()
        let presenter = EditTodoPresenter(data: data)
        let interactor = EditTodoInteractor()
        let router = EditTodoRouter()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        router.viewController = view
        router.todoListViewController = todoListViewController
        
        return view
    }
}
