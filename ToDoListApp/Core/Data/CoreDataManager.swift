//
//  CoreDataManager.swift
//  ToDoListApp
//
//  Created by Evan Brother on 03.02.2026.
//

internal import Foundation
import CoreData

// MARK: Manager
final class CoreDataManager {
    
    // MARK: Singleton
    static let shared = CoreDataManager()
    
    private init() {}
    
    // MARK: Properties
    private let coreDataStack = CoreDataStack.shared
    
    // MARK: Load Initial Data
    func loadInitialDataFromAPI(completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        let hasLoadedInitialData = UserDefaults.standard.bool(forKey: Constants.hasLoadedInitialData)
        
        if hasLoadedInitialData {
            self.fetchAll(completion: completion)
            return
        }
        
#if DEBUG
        print("First launch: loading initial data from API...")
#endif
        
        NetworkService.shared.fetchInitialTodoItems { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let dtoItems):
#if DEBUG
                print("Loaded \(dtoItems.count) todos from API")
#endif
                
                self.saveFromDTOs(dtoItems) { saveResult in
                    switch saveResult {
                    case .success(let todoItems):
                        UserDefaults.standard.set(true, forKey: Constants.hasLoadedInitialData)
                        completion(.success(todoItems))
                        
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
                
            case .failure(let error):
#if DEBUG
                print("Failed to load from API: \(error.localizedDescription)")
#endif
                
                self.fetchAll { fetchResult in
                    switch fetchResult {
                    case .success(let todoItems):
                        if todoItems.isEmpty {
                            completion(.failure(error))
                        } else {
#if DEBUG
                            print("Using existing local data")
#endif
                            
                            completion(.success(todoItems))
                        }
                    case .failure(let fetchError):
                        completion(.failure(fetchError))
                    }
                }
            }
        }
    }
    
    // MARK: Helper Methods
    private func performFetch<T>(_ fetchRequest: NSFetchRequest<T>, completion: @escaping (Result<[T], Error>) -> Void) where T: NSManagedObject {
        self.coreDataStack.performBackgroundTask { context in
            do {
                let results = try context.fetch(fetchRequest)
                
                DispatchQueue.main.async {
                    completion(.success(results))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}

// MARK: - Manager Protocol
extension CoreDataManager: CoreDataManagerProtocol {
    
    // MARK: CRUD Operations
    
    /// Fetch all todo items sorted by creation date (newest first)
    func fetchAll(completion: @escaping (Result<[TodoItem], any Error>) -> Void) {
        let fetchRequest: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "createdDate", ascending: false)
        ]
        
        self.performFetch(fetchRequest, completion: completion)
    }
    
    /// Fetch todo item by ID
    func fetch(by id: UUID, completion: @escaping (Result<TodoItem?, any Error>) -> Void) {
        let fetchRequest: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.fetchLimit = 1
        
        self.performFetch(fetchRequest) { result in
            switch result {
            case .success(let todos):
                completion(.success(todos.first))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Create new todo item
    func create(title: String, description: String?, completion: @escaping (Result<TodoItem, any Error>) -> Void) {
        
        self.coreDataStack.performBackgroundTask { context in
            let item = TodoItem(context: context)
            
            item.id = UUID()
            item.title = title
            item.desc = description
            item.isCompleted = false
            item.createdDate = Date()
            
            do {
                if context.hasChanges {
                    try context.save()
                }
                
                DispatchQueue.main.async {
                    completion(.success(item))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    /// Update existing todo item
    func update(_ item: TodoItem, title: String?, description: String?, isCompleted: Bool?, completion: @escaping (Result<Void, any Error>) -> Void) {
        self.coreDataStack.performBackgroundTask { context in
            guard let objectID = item.objectID.uriRepresentation().absoluteString.data(using: .utf8) else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "CoreData", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid object ID"])))
                }
                return
            }
            
            guard let managedObject = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: URL(string: String(data: objectID, encoding: .utf8)!)!) else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "CoreData", code: -1, userInfo: [NSLocalizedDescriptionKey: "Object not found"])))
                }
                return
            }
            
            let todoToUpdate = context.object(with: managedObject) as! TodoItem
            
            if let title = title {
                todoToUpdate.title = title
            }
            
            if let description = description {
                todoToUpdate.desc = description
            }
            
            if let isCompleted = isCompleted {
                todoToUpdate.isCompleted = isCompleted
            }
            
            do {
                if context.hasChanges {
                    try context.save()
                }
                
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    /// Delete todo item
    func delete(_ item: TodoItem, completion: @escaping (Result<Void, any Error>) -> Void) {
        self.coreDataStack.performBackgroundTask { context in
            guard let objectID = item.objectID.uriRepresentation().absoluteString.data(using: .utf8) else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "CoreData", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid object ID"])))
                }
                return
            }
            
            guard let managedObject = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: URL(string: String(data: objectID, encoding: .utf8)!)!) else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "CoreData", code: -1, userInfo: [NSLocalizedDescriptionKey: "Object not found"])))
                }
                return
            }
            
            let todoToDelete = context.object(with: managedObject)
            
            context.delete(todoToDelete)
            
            do {
                if context.hasChanges {
                    try context.save()
                }
                
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: Search
    
    /// Search todos by title or description
    func search(with query: String, completion: @escaping (Result<[TodoItem], any Error>) -> Void) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return self.fetchAll(completion: completion)
        }
        
        let fetchRequest: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(
            format: "title CONTAINS[cd] %@ OR desc CONTAINS[cd] %@",
            query, query
        )
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "createdDate", ascending: false)
        ]
        
        self.performFetch(fetchRequest, completion: completion)
    }
    
    // MARK: Bulk Operations
    
    /// Save todo items from DTOs (for initial API loading)
    func saveFromDTOs(_ items: [LightTodoItem], completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        self.coreDataStack.performBackgroundTask { context in
            // First, delete existing todos with serverIds
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TodoItem.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.execute(deleteRequest)
                
                // Create new todos from DTOs
                for item in items {
                    _ = item.toCoreDataEntity(context: context)
                }
                
                if context.hasChanges {
                    try context.save()
                }
                
                DispatchQueue.main.async {
                    self.fetchAll(completion: completion)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    /// Delete all todo items
    func deleteAll(completion: @escaping (Result<Void, any Error>) -> Void) {
        self.coreDataStack.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TodoItem.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.execute(deleteRequest)
                
                if context.hasChanges {
                    try context.save()
                }
                
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
