//
//  TodoListInteractorProtocol.swift
//  ToDoListApp
//
//  Created by Evan Brother on 02.02.2026.
//

protocol TodoListInteractorProtocol: AnyObject {
    func fetchTasks()
    func refreshTasks()
    func searchTasks(with query: String)
    func toggleTaskCompletion(_ task: TodoTask)
    func deleteTask(_ task: TodoTask)
}
