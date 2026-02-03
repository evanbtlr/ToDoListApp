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
}


