//
//  EditTodoData.swift
//  ToDoListApp
//
//  Created by Evan Brother on 04.02.2026.
//

import Foundation

struct EditTodoData {
    var id: UUID?
    var title: String
    var description: String?
    var isCompleted: Bool
    
    init(id: UUID? = nil,
         title: String = "",
         description: String? = nil,
         isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.description = description
        self.isCompleted = isCompleted
    }
    
    // MARK: - Validation
    var isValid: Bool {
        return !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var validationErrorMessage: String? {
        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return String(localized: .errorValidationTitle)
        }
        
        return nil
    }
    
    // MARK: - Mapping
    init(from task: TodoTask) {
        self.id = task.id
        self.title = task.title
        self.description = task.description
        self.isCompleted = task.isCompleted
    }
    
    func toTodoTask() -> TodoTask {
        return TodoTask(
            id: self.id ?? UUID(),
            title: self.title,
            description: self.description,
            createdAt: Date(),
            isCompleted: self.isCompleted
        )
    }
}
