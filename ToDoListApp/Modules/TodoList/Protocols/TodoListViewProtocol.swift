//
//  TodoListViewProtocol.swift
//  ToDoListApp
//
//  Created by Evan Brother on 02.02.2026.
//

protocol TodoListViewProtocol: AnyObject {
    func showTasks(_ tasks: [TodoTask])
    func showLoading()
    func hideLoading()
    func showError(_ message: String)
}
