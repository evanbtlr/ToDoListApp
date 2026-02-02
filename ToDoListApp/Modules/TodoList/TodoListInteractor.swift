//
//  TodoListInteractor.swift
//  ToDoListApp
//
//  Created by Evan Brother on 02.02.2026.
//

import Foundation

// MARK: - Interactor
final class TodoListInteractor {
    
    // MARK: Properties
    weak var presenter: TodoListInteractorOutputProtocol?
}

// MARK: - Interactor Protocol
extension TodoListInteractor: TodoListInteractorProtocol {
    func fetchTasks() {
        // TODO: Fetch from CoreData/API
        
        // For now, return dummy data
        let dummyTasks = [
            TodoTask(title: "Buy groceries", description: "Milk, Eggs, Bread"),
            TodoTask(title: "Finish project", description: "VIPER implementation")
        ]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.presenter?.tasksFetched(dummyTasks)
        }
    }
    
    func searchTasks(with query: String) {
        // TODO: Implement search
    }
    
    func toggleTaskCompletion(_ task: TodoTask) {
        // TODO: Toggle completion
    }
    
    func deleteTask(_ task: TodoTask) {
        // TODO: Delete task
    }
}
