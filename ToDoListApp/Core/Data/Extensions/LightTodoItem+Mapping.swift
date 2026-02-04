//
//  LightTodoItem+Mapping.swift
//  ToDoListApp
//
//  Created by Evan Brother on 03.02.2026.
//

internal import Foundation
import CoreData

// MARK: - Mapping to CoreData Entity
extension LightTodoItem {
    func toCoreDataEntity(context: NSManagedObjectContext) -> TodoItem {
        let item = TodoItem(context: context)
        
        item.id = UUID()
        item.title = self.title
        item.desc = nil
        item.createdDate = Date()
        item.isCompleted = self.completed
        item.serverId = Int32(self.id)
        
        return item
    }
}
