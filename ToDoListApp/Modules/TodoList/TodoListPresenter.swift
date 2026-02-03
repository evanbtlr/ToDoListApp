//
//  TodoListPresenter.swift
//  ToDoListApp
//
//  Created by Evan Brother on 02.02.2026.
//

import Foundation

// MARK: - Presenter
final class TodoListPresenter {
    
    // MARK: Properties
    weak var view: TodoListViewProtocol?
    var interactor: TodoListInteractorProtocol?
    var router: TodoListRouterProtocol?
    
    private var tasks: [TodoTask] = []
    private var filteredTasks: [TodoTask] = []
    
    // MARK: Private Methods
    private func loadTasks() {
        self.view?.showLoading()
        self.interactor?.fetchTasks()
    }
}

// MARK: - Presenter Protocol
extension TodoListPresenter: TodoListPresenterProtocol {
    func viewDidLoad() {
        self.loadTasks()
    }
    
    func didTapAddButton() {
        self.router?.navigateToAddTask()
    }
    
    func didReqiredRefresh() {
        self.interactor?.refreshTasks()
    }
    
    func didSelectTask(at index: Int) {
        // TODO: Navigate to edit
    }
    
    func didToggleTaskCompletion(at index: Int) {
        // TODO: Toggle completion
    }
    
    func didDeleteTask(at index: Int) {
        // TODO: Delete task
    }
    
    func searchTasks(with query: String) {
        // TODO: Impelement search
    }
}

// MARK: - Interactor Output Protocol
extension TodoListPresenter: TodoListInteractorOutputProtocol {
    func tasksFetched(_ tasks: [TodoTask]) {
        self.tasks = tasks
        self.filteredTasks = tasks
        
        self.view?.hideLoading()
        self.view?.showTasks(tasks)
    }
    
    func tasksFetchFailed(_ error: any Error) {
        self.view?.hideLoading()
        self.view?.showError(error.localizedDescription)
    }
}
