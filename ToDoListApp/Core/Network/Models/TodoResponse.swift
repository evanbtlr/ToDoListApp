//
//  LightTodoItemResponse.swift
//  ToDoListApp
//
//  Created by Evan Brother on 03.02.2026.
//

struct TodoResponse: nonisolated Decodable {
    let tasks: [LightTodoItem]
    let total: Int
    let skip: Int
    let limit: Int
    
    enum CodingKeys: String, CodingKey {
        case tasks = "todos"
        case total
        case skip
        case limit
    }
}
