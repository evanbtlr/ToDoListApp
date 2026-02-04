//
//  MockTodoListView.swift
//  ToDoListApp
//
//  Created by Evan Brother on 04.02.2026.
//

import XCTest
@testable import ToDoListApp

final class MockTodoListView: TodoListViewProtocol {
    
    var showTasksCalled = false
    var tasksShown: [TodoTask] = []
    var showLoadingCalled = false
    var hideLoadingCalled = false
    var showErrorCalled = false
    var errorShown: String?
    var showRefreshControlCalled = false
    var hideRefreshControlCalled = false
    var showEmptyStateCalled = false
    var hideEmptyStateCalled = false
    
    var searchText: String? = nil
    
    func showTasks(_ tasks: [TodoTask]) {
        self.showTasksCalled = true
        self.tasksShown = tasks
    }
    
    func showLoading() {
        self.showLoadingCalled = true
    }
    
    func hideLoading() {
        self.hideLoadingCalled = true
    }
    
    func showError(_ message: String) {
        self.showErrorCalled = true
        self.errorShown = message
    }
    
    func showRefreshControl() {
        self.showRefreshControlCalled = true
    }
    
    func hideRefreshControl() {
        self.hideRefreshControlCalled = true
    }
    
    func updateEmptyState() {
        self.showEmptyStateCalled = true
    }
}
