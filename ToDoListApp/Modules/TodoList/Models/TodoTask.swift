//
//  TodoTask.swift
//  ToDoListApp
//
//  Created by Evan Brother on 02.02.2026.
//

import Foundation
import CoreData

struct TodoTask {
    let id: UUID
    let title: String
    let description: String?
    let createdAt: Date
    let isCompleted: Bool
    
    init(id: UUID = UUID(),
         title: String,
         description: String? = nil,
         createdAt: Date = Date(),
         isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.description = description
        self.createdAt = createdAt
        self.isCompleted = isCompleted
    }
    
    // MARK: Mapping from CoreData
    init(from todoItem: TodoItem) {
        self.id = todoItem.id ?? UUID()
        self.title = todoItem.title ?? ""
        self.description = todoItem.desc
        self.createdAt = todoItem.createdDate ?? .now
        self.isCompleted = todoItem.isCompleted
    }
    
    // MARK: Mapping to CoreData (in CoreDataManager)
    func toTodoItem(context: NSManagedObjectContext) -> TodoItem {
        return TodoItem(
            context: context,
            id: id,
            title: title,
            description: description,
            createdDate: createdAt,
            isCompleted: isCompleted
        )
    }
}

// MARK: - Equatable
extension TodoTask: Equatable {
    static func == (lhs: TodoTask, rhs: TodoTask) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Hashable
extension TodoTask: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Mock Data
extension TodoTask {
    static var mock: TodoTask {
        return TodoTask(
            title: "Test Task",
            description: "This is a test task",
            isCompleted: false
        )
    }
    
    static var mockArray: [TodoTask] {
        return [
            TodoTask(title: "Buy groceries", description: "Milk, Eggs, Bread"),
            TodoTask(title: "Finish project", description: "VIPER implementation", isCompleted: true),
            TodoTask(title: "Call mom", description: "Birthday call")
        ]
    }
}
