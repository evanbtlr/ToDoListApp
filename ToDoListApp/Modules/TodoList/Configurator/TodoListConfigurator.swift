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
}
