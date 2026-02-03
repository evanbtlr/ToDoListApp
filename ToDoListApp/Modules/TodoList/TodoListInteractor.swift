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
    private let coreDataManager = CoreDataManager.shared
    
    // MARK: Private Methods
        private func handleFetchResult(_ result: Result<[TodoItem], Error>) {
            switch result {
            case .success(let todoItems):
                let tasks = todoItems.map { TodoTask(from: $0) }
                self.presenter?.tasksFetched(tasks)
            case .failure(let error):
                self.presenter?.tasksFetchFailed(error)
            }
        }
}

// MARK: - Interactor Protocol
extension TodoListInteractor: TodoListInteractorProtocol {
    func fetchTasks() {
        self.coreDataManager.fetchAll { [weak self] result in
            self?.handleFetchResult(result)
        }
    }
    
    func searchTasks(with query: String) {
        self.coreDataManager.search(with: query) { [weak self] result in
            self?.handleFetchResult(result)
        }
    }
    
    func toggleTaskCompletion(_ task: TodoTask) {
        // First fetch the TodoItem by ID
        self.coreDataManager.fetch(by: task.id) { [weak self] result in
            switch result {
            case .success(let todoItem):
                if let todoItem = todoItem {
                    let newCompletionStatus = !todoItem.isCompleted
                    self?.coreDataManager.update(
                        todoItem,
                        title: nil,
                        description: nil,
                        isCompleted: newCompletionStatus
                    ) { updateResult in
                        switch updateResult {
                        case .success:
                            self?.fetchTasks() // Refresh the list
                        case .failure(let error):
                            self?.presenter?.tasksFetchFailed(error)
                        }
                    }
                }
            case .failure(let error):
                self?.presenter?.tasksFetchFailed(error)
            }
        }
    }
    
    func deleteTask(_ task: TodoTask) {
        // First fetch the TodoItem by ID
        self.coreDataManager.fetch(by: task.id) { [weak self] result in
            switch result {
            case .success(let todoItem):
                if let todoItem = todoItem {
                    self?.coreDataManager.delete(todoItem) { deleteResult in
                        switch deleteResult {
                        case .success:
                            self?.fetchTasks() // Refresh the list
                        case .failure(let error):
                            self?.presenter?.tasksFetchFailed(error)
                        }
                    }
                }
            case .failure(let error):
                self?.presenter?.tasksFetchFailed(error)
            }
        }
    }
}
