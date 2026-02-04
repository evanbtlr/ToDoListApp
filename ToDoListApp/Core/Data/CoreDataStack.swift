//
//  CoreDataStack.swift
//  ToDoListApp
//
//  Created by Evan Brother on 03.02.2026.
//

import CoreData

final class CoreDataStack {
    
    // MARK: Singleton
    static let shared = CoreDataStack()
    
    init(inMemory: Bool = false) {
        self.inMemory = inMemory
    }
    
    // MARK: Properties
    private let inMemory: Bool
    private let modelName = "TodoModel"
    
    // MARK: Persistent Container
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            
#if DEBUG
            print("CoreData store loaded: \(storeDescription.url?.absoluteString ?? "")")
#endif
        }
        
        // Merge changes from background contexts
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return container
    }()
    
    // MARK: Contexts
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    lazy var backgroundContext: NSManagedObjectContext = {
        self.newBackgroundContext()
    }()
    
    func newBackgroundContext() -> NSManagedObjectContext {
        let backgroundContext = persistentContainer.newBackgroundContext()
        
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return backgroundContext
    }
    
    // MARK: Save Methods
    func saveViewContext() {
        guard viewContext.hasChanges else { return }
        
        do {
            try viewContext.save()
            
#if DEBUG
            print("View context saved successfully")
#endif
        } catch {
#if DEBUG
            print("Failed to save view context: \(error)")
#endif
            
            viewContext.rollback()
        }
    }
    
    // MARK: Helper Methods
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.backgroundContext
        
        context.performAndWait {
            block(context)
        }
    }
}
