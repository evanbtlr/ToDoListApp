//
//  MockTodoListInteractor.swift
//  ToDoListApp
//
//  Created by Evan Brother on 04.02.2026.
//

import XCTest
@testable import ToDoListApp

final class MockTodoListInteractor: TodoListInteractorProtocol {
    var fetchTasksCalled = false
    var refreshTasksCalled = false
    var searchTasksCalled = false
    var searchQuery: String?
    var toggleTaskCompletionCalled = false
    var toggleTask: TodoTask?
    var deleteTaskCalled = false
    var deleteTask: TodoTask?
    
    func fetchTasks() {
        self.fetchTasksCalled = true
    }
    
    func refreshTasks() {
        self.refreshTasksCalled = true
    }
    
    func searchTasks(with query: String) {
        self.searchTasksCalled = true
        self.searchQuery = query
    }
    
    func toggleTaskCompletion(_ task: TodoTask) {
        self.toggleTaskCompletionCalled = true
        self.toggleTask = task
    }
    
    func deleteTask(_ task: TodoTask) {
        self.deleteTaskCalled = true
        self.deleteTask = task
    }
}
