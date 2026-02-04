//
//  EditTodoRouterProtocol.swift
//  ToDoListApp
//
//  Created by Evan Brother on 04.02.2026.
//

import UIKit

protocol EditTodoRouterProtocol: AnyObject {
    var viewController: UIViewController? { get set }
    
    func closeModule(animated: Bool)
    func closeModuleWithRefresh()
}
