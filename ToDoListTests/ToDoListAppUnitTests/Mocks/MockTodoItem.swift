//
//  MockTodoItem.swift
//  ToDoListApp
//
//  Created by Evan Brother on 04.02.2026.
//

import CoreData
@testable import ToDoListApp

extension TodoItem {
    static func mock(
        context: NSManagedObjectContext,
        id: UUID = UUID(),
        title: String = "Test Task",
        description: String? = "Test Description",
        createdDate: Date = Date(),
        isCompleted: Bool = false,
        serverId: Int32 = 1
    ) -> TodoItem {
        let todoItem = TodoItem(context: context)
        
        todoItem.id = id
        todoItem.title = title
        todoItem.desc = description
        todoItem.createdDate = createdDate
        todoItem.isCompleted = isCompleted
        todoItem.serverId = serverId
        
        return todoItem
    }
}

extension TodoTask {
    static func mock(
        id: UUID = UUID(),
        title: String = "Test Task",
        description: String? = "Test Description",
        createdAt: Date = Date(),
        isCompleted: Bool = false
    ) -> TodoTask {
        return TodoTask(
            id: id,
            title: title,
            description: description,
            createdAt: createdAt,
            isCompleted: isCompleted
        )
    }
}
