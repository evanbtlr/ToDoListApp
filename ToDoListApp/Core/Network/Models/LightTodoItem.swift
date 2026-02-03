//
//  LightTodoItem.swift
//  ToDoListApp
//
//  Created by Evan Brother on 03.02.2026.
//

struct LightTodoItem: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case todo
        case completed
        case userId
    }
    
    // MARK: - Initializer with default values
    init(id: Int, todo: String, completed: Bool, userId: Int) {
        self.id = id
        self.todo = todo
        self.completed = completed
        self.userId = userId
    }
}
