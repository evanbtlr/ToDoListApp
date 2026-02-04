//
//  EditTodoInteractorProtocol.swift
//  ToDoListApp
//
//  Created by Evan Brother on 04.02.2026.
//

protocol EditTodoInteractorProtocol: AnyObject {
    func save(_ data: EditTodoData, completion: @escaping (Result<TodoTask, Error>) -> Void)
    func update(_ data: EditTodoData, completion: @escaping (Result<TodoTask, Error>) -> Void)
}
