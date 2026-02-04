//
//  EditTodoInteractor.swift
//  ToDoListApp
//
//  Created by Evan Brother on 04.02.2026.
//

internal import Foundation

final class EditTodoInteractor {
    
    // MARK: Properties
    private let coreDataManager = CoreDataManager.shared
}

// MARK: - Edit Todo Interactor Protocol
extension EditTodoInteractor: EditTodoInteractorProtocol {
    func save(_ data: EditTodoData, completion: @escaping (Result<TodoTask, Error>) -> Void) {
        self.coreDataManager.create(title: data.title, description: data.description) { result in
            switch result {
            case .success(let todoItem):
                let task = TodoTask(from: todoItem)
                
                DispatchQueue.main.async {
                    completion(.success(task))
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func update(_ data: EditTodoData, completion: @escaping (Result<TodoTask, Error>) -> Void) {
        guard let id = data.id else {
            completion(.failure(EditTodoInteractorError.invalidTaskId))
            return
        }
        
        // First fetch the existing todo
        coreDataManager.fetch(by: id) { [weak self] fetchResult in
            guard let self = self else { return }
            
            switch fetchResult {
            case .success(let todoItem):
                guard let todoItem = todoItem else {
                    completion(.failure(EditTodoInteractorError.taskNotFound))
                    return
                }
                
                // Update the todo
                self.coreDataManager.update(todoItem, title: data.title, description: data.description, isCompleted: data.isCompleted) { updateResult in
                    switch updateResult {
                    case .success:
                        // Fetch updated todo
                        self.coreDataManager.fetch(by: id) { finalResult in
                            switch finalResult {
                            case .success(let updatedItem):
                                guard let updatedItem = updatedItem else {
                                    completion(.failure(EditTodoInteractorError.taskNotFoundAfterUpdate))
                                    return
                                }
                                
                                let task = TodoTask(from: updatedItem)
                                
                                completion(.success(task))
                                
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                        
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Network Errors
enum EditTodoInteractorError: LocalizedError {
    case invalidTaskId
    case taskNotFound
    case taskNotFoundAfterUpdate
    
    var errorDescription: String? {
        switch self {
        case .invalidTaskId:
            return String(localized: .errorEditInvalidId)
        case .taskNotFound:
            return String(localized: .errorEditNotFound)
        case .taskNotFoundAfterUpdate:
            return String(localized: .errorEditNotFoundAfterUpdate)
        }
    }
}
