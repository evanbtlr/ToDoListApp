//
//  LightTodoItemResponse.swift
//  ToDoListApp
//
//  Created by Evan Brother on 03.02.2026.
//

import Foundation

struct TodoResponse: Decodable {
    let todos: [LightTodoItem]
    let total: Int
    let skip: Int
    let limit: Int
}
