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
    
    private init() {}
    
    // MARK: Properties
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
    
    func newBackgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
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
    
    func saveBackgroundContext(_ context: NSManagedObjectContext) {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
            
#if DEBUG
            print("Background context saved successfully")
#endif
        } catch {
#if DEBUG
            print("Failed to save background context: \(error)")
#endif
            
            context.rollback()
        }
    }
    
    // MARK: Helper Methods
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask { context in
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            block(context)
            
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
#if DEBUG
                    print("Background task save failed: \(error)")
#endif
                }
            }
        }
    }
}
