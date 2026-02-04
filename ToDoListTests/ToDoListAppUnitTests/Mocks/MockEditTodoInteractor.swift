//
//  Untitled.swift
//  ToDoListApp
//
//  Created by Evan Brother on 04.02.2026.
//

import CoreData
@testable import ToDoListApp

final class MockEditTodoInteractor: EditTodoInteractorProtocol {
    var saveTodoCalled = false
    var savedData: EditTodoData?
    var updateTodoCalled = false
    var updatedData: EditTodoData?
    
    func save(_ data: EditTodoData, completion: @escaping (Result<TodoTask, Error>) -> Void) {
        self.saveTodoCalled = true
        self.savedData = data
    }
    
    func update(_ data: EditTodoData, completion: @escaping (Result<TodoTask, Error>) -> Void) {
        self.updateTodoCalled = true
        self.updatedData = data
    }
}
