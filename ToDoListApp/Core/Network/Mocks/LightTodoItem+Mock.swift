//
//  LightTodoItem+Mock.swift
//  ToDoListApp
//
//  Created by Evan Brother on 03.02.2026.
//

extension LightTodoItem {
    static var mock: LightTodoItem {
            return LightTodoItem(
                id: 1,
                todo: "Buy groceries",
                completed: false,
                userId: 1
            )
        }
        
        static var mockArray: [LightTodoItem] {
            return [
                LightTodoItem(id: 1, todo: "Buy groceries", completed: false, userId: 1),
                LightTodoItem(id: 2, todo: "Finish project", completed: true, userId: 1),
                LightTodoItem(id: 3, todo: "Call mom", completed: false, userId: 1)
            ]
        }
}
