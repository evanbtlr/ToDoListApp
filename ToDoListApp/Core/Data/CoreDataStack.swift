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
        
        if inMemory {
            guard let defaultStoreDescription = container.persistentStoreDescriptions.first else {
                Logger.log(.fatal, "Failed to retrieve default persistent store description.")
                
                fatalError("Failed to retrieve default persistent store description.")
            }
            
            defaultStoreDescription.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                Logger.log(.fatal, "Unresolved error \(error), \(error.userInfo)")
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            
#if DEBUG
            Logger.info("CoreData store loaded: \(storeDescription.url?.absoluteString ?? "")")
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
            Logger.info("View context saved successfully")
#endif
        } catch {
#if DEBUG
            Logger.error("Failed to save view context: \(error)")
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
