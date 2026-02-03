//
//  LightTodoItem+Mapping.swift
//  ToDoListApp
//
//  Created by Evan Brother on 03.02.2026.
//

import Foundation
import CoreData

// MARK: - Mapping to CoreData Entity
extension LightTodoItem {
    func toCoreDataEntity(context: NSManagedObjectContext) -> TodoItem {
            return TodoItem(
                context: context,
                title: self.todo,
                description: nil,
                isCompleted: self.completed,
                serverId: Int32(self.id)
            )
        }
}
