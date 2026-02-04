//
//  TodoListViewProtocol.swift
//  ToDoListApp
//
//  Created by Evan Brother on 02.02.2026.
//

protocol TodoListViewProtocol: AnyObject {
    var searchText: String? { get }
    
    func showTasks(_ tasks: [TodoTask])
    
    func showLoading()
    func hideLoading()
    
    func showRefreshControl()
    func hideRefreshControl()
    
    func updateEmptyState()
    
    func showError(_ message: String)
}
