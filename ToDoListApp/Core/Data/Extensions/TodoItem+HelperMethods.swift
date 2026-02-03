//
//  TodoItem+HelperMethods.swift
//  ToDoListApp
//
//  Created by Evan Brother on 03.02.2026.
//

extension TodoItem {
    func toggleCompletion() {
        isCompleted.toggle()
    }
    
    func update(title: String, description: String?) {
        self.title = title
        self.desc = description
    }
}
