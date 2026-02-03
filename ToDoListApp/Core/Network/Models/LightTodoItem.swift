//
//  LightTodoItem.swift
//  ToDoListApp
//
//  Created by Evan Brother on 03.02.2026.
//

struct LightTodoItem: Codable {
    let id: Int
    let title: String
    let completed: Bool
    let userId: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case title = "todo"
        case completed
        case userId
    }
    
    // MARK: - Initializer with default values
    init(id: Int, title: String, completed: Bool, userId: Int) {
        self.id = id
        self.title = title
        self.completed = completed
        self.userId = userId
    }
}
