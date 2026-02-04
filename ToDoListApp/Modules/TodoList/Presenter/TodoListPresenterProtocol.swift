//
//  TodoListPresenterProtocol.swift
//  ToDoListApp
//
//  Created by Evan Brother on 02.02.2026.
//

protocol TodoListPresenterProtocol: AnyObject {
    func viewDidLoad()
    func handleViewWillAppear()
    
    func didTapAddButton()
    func didReqiredRefresh()
    
    func didSelectTask(at index: Int)
    func didToggleTaskCompletion(at index: Int)
    func didDeleteTask(at index: Int)
    
    func searchTasks(with query: String)
}
