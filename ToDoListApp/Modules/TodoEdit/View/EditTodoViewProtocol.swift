//
//  EditTodoViewProtocol.swift
//  ToDoListApp
//
//  Created by Evan Brother on 04.02.2026.
//

protocol EditTodoViewProtocol: AnyObject {
    func showData(_ data: EditTodoData)
    func showValidationError(_ message: String)
    
    func clearValidationError()
    
    func showLoading()
    func hideLoading()
    
    func showError(_ message: String)
    
    func closeModule()
}
