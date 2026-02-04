//
//  TodoListRouterProtocol.swift
//  ToDoListApp
//
//  Created by Evan Brother on 02.02.2026.
//

import UIKit

protocol TodoListRouterProtocol: AnyObject {
    var viewController: UIViewController? { get set }
    
    func navigateToAddTask()
    func navigateToEditTask(_ task: TodoTask)
}
