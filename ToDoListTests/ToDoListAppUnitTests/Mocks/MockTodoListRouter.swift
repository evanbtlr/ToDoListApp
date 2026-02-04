//
//  MockTodoListRouter.swift
//  ToDoListApp
//
//  Created by Evan Brother on 04.02.2026.
//

import XCTest
@testable import ToDoListApp

final class MockTodoListRouter: TodoListRouterProtocol {
    var viewController: UIViewController?
    var navigateToAddTaskCalled = false
    var navigateToEditTaskCalled = false
    var taskToEdit: TodoTask?
    
    func navigateToAddTask() {
        self.navigateToAddTaskCalled = true
    }
    
    func navigateToEditTask(_ task: TodoTask) {
        self.navigateToEditTaskCalled = true
        self.taskToEdit = task
    }
}
