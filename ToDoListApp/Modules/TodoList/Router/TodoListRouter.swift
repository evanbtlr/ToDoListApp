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
    static func createModule() -> UIViewController {
        let view = TodoListViewController()
        let presenter = TodoListPresenter()
        let interactor = TodoListInteractor()
        let router = TodoListRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    func navigateToAddTask() {
        // TODO: Navigate to add task screen
        print("Navigate to add task")
    }
    
    func navigateToEditTask(_ task: TodoTask) {
        // TODO: Navigate to edit task screen
        print("Navigate to edit task")
    }
    
    
}
