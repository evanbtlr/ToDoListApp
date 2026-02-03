//
//  CoreDataManager.swift
//  ToDoListApp
//
//  Created by Evan Brother on 03.02.2026.
//

import Foundation
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
            case .success(let items):
#if DEBUG
                print("Loaded \(items.count) todos from API")
#endif
                
                self.coreDataStack.performBackgroundTask { context in
                    do {
                        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TodoItem.fetchRequest()
                        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                        try context.execute(deleteRequest)
                        
                        for item in items {
                            let newItem = item.toCoreDataEntity(context: context)
                            print(newItem.description)
                        }
                        
                        if context.hasChanges {
                            try context.save()
                            
                            UserDefaults.standard.set(true, forKey: Constants.hasLoadedInitialData)
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
    
    private func handleInitialTodoItems(_ items: [LightTodoItem], completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        
        let context = self.coreDataStack.newBackgroundContext()
        
        context.perform {
            do {
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TodoItem.fetchRequest()
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                try context.execute(deleteRequest)
                
                for item in items {
                    _ = item.toCoreDataEntity(context: context)
                }
                
                if context.hasChanges {
                    try context.save()
                }
                

                self.coreDataStack.viewContext.perform {
                    do {
                        try self.coreDataStack.viewContext.save()
                    } catch {
                        print("Error saving view context: \(error)")
                    }
                }
                
                // 6. Отмечаем загрузку
                UserDefaults.standard.set(true, forKey: "hasLoadedInitialData")
                
                // 7. Читаем из ТОГО ЖЕ контекста
                let fetchRequest2: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
                fetchRequest2.sortDescriptors = [
                    NSSortDescriptor(key: "createdDate", ascending: false)
                ]
                
                
                let savedItems = try context.fetch(fetchRequest2)
                print("✅ Now have \(savedItems.count) items in CoreData (background context)")
                
                // 8. Преобразуем в объекты главного контекста
                let objectIDs = savedItems.map { $0.objectID }
                
                DispatchQueue.main.async {
                    let mainContext = self.coreDataStack.viewContext
                    let mainThreadItems = objectIDs.compactMap { try? mainContext.existingObject(with: $0) as? TodoItem }
                    
                    print("✅ Converted to \(mainThreadItems.count) items in main context")
                    completion(.success(mainThreadItems))
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
                try context.save()
                
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
                try context.save()
                
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
                try context.save()
                
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
    
    /// Delete all todo items
    func deleteAll(completion: @escaping (Result<Void, any Error>) -> Void) {
        self.coreDataStack.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TodoItem.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.execute(deleteRequest)
                try context.save()
                
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
