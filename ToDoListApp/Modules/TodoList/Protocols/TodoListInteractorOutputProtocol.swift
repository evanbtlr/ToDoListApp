//
//  TodoListInteractorOutputProtocol.swift
//  ToDoListApp
//
//  Created by Evan Brother on 02.02.2026.
//

protocol TodoListInteractorOutputProtocol: AnyObject {
    func tasksFetched(_ tasks: [TodoTask])
    func tasksFetchFailed(_ error: Error)
}
