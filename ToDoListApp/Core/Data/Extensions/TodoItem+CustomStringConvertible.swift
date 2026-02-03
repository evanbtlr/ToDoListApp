//
//  TodoItem+CustomStringConvertible.swift
//  ToDoListApp
//
//  Created by Evan Brother on 03.02.2026.
//

internal import Foundation

extension TodoItem {
    public override var description: String {
        return """
            TodoItem(
                id: \(self.id?.uuidString ?? "nil"),
                title: \(self.title ?? "nil"),
                isCompleted: \(self.isCompleted.description),
                createdDate: \(self.createdDate?.description ?? "nil")
            )
            """
    }
}
