//
//  TodoItem+CoreDataProperties.swift
//  ToDoListApp
//
//  Created by Evan Brother on 03.02.2026.
//
//

public import Foundation
public import CoreData


public typealias TodoItemCoreDataPropertiesSet = NSSet

extension TodoItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoItem> {
        return NSFetchRequest<TodoItem>(entityName: "TodoItem")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var desc: String?
    @NSManaged public var createdDate: Date?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var serverId: Int32
    
    // MARK: Convenience Initializer
    @discardableResult
    convenience init(context: NSManagedObjectContext,
                     id: UUID = UUID(),
                     title: String,
                     description: String? = nil,
                     createdDate: Date = Date(),
                     isCompleted: Bool = false,
                     serverId: Int32 = 0) {
        
        self.init(context: context)
        self.id = id
        self.title = title
        self.desc = description
        self.createdDate = createdDate
        self.isCompleted = isCompleted
        self.serverId = serverId
    }
    
    // MARK: Helper Methods
    func toggleCompletion() {
        isCompleted.toggle()
    }
    
    func update(title: String, description: String?) {
        self.title = title
        self.desc = description
    }
}

extension TodoItem: Identifiable {

}

extension TodoItem {
    public override var description: String {
        return """
            TodoItem(
                id: \(self.id?.uuidString ?? "nil"),
                title: \(self.title ?? "nil"),
                isCompleted: \(self.isCompleted.description),
                createdDate: \(self.createdDate?.description ?? "nil")
            )
            """
    }
}
