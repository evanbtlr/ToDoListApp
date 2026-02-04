//
//  MockEditTodoView.swift
//  ToDoListApp
//
//  Created by Evan Brother on 04.02.2026.
//

import CoreData
@testable import ToDoListApp

final class MockEditTodoView: EditTodoViewProtocol {
    var showDataCalled = false
    var shownData: EditTodoData?
    var showValidationErrorCalled = false
    var clearValidationErrorCalled = false
    var showLoadingCalled = false
    var hideLoadingCalled = false
    var showErrorCalled = false
    
    func showData(_ data: EditTodoData) {
        self.showDataCalled = true
        self.shownData = data
    }
    
    func showValidationError(_ message: String) {
        self.showValidationErrorCalled = true
    }
    
    func clearValidationError() {
        self.clearValidationErrorCalled = true
    }
    
    func showLoading() {
        self.showLoadingCalled = true
    }
    
    func hideLoading() {
        self.hideLoadingCalled = true
    }
    
    func showError(_ message: String) {
        self.showErrorCalled = true
    }
    
    func closeModule() {
        // Not needed for presenter tests
    }
}
