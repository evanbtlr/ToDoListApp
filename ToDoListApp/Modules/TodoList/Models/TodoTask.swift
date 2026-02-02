//
//  TodoTask.swift
//  ToDoListApp
//
//  Created by Evan Brother on 02.02.2026.
//

import Foundation

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
}
