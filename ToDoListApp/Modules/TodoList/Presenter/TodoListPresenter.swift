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
    
    private(set) var allTasks: [TodoTask] = []
    private(set) var filteredTasks: [TodoTask] = []
    private(set) var isSearching = false
    
    private var actualTasks: [TodoTask] {
        self.isSearching ? self.filteredTasks : self.allTasks
    }
    
    // MARK: Methods
    func set(tasks: [TodoTask]) {
        self.allTasks = tasks
        
        self.updateFilteredTasks(with: self.view?.searchText)
    }
    
    // MARK: Private Methods
    private func updateFilteredTasks(with query: String?) {
        guard let query = query, !query.isEmpty, self.isSearching else {
            self.filteredTasks = self.allTasks
            return
        }
        
        self.filteredTasks = self.allTasks.filter {
            $0.title.localizedCaseInsensitiveContains(query) ||
            ($0.description?.localizedCaseInsensitiveContains(query) ?? false)
        }
    }
}

// MARK: - Presenter Protocol
extension TodoListPresenter: TodoListPresenterProtocol {
    func viewDidLoad() {
        self.view?.showLoading()
        self.interactor?.fetchTasks()
    }
    
    func handleViewWillAppear() {
        self.interactor?.fetchTasks()
    }
    
    func didTapAddButton() {
        self.router?.navigateToAddTask()
    }
    
    func didReqiredRefresh() {
        self.interactor?.refreshTasks()
    }
    
    func didSelectTask(at index: Int) {
        let task = self.actualTasks[index]
        self.router?.navigateToEditTask(task)
    }
    
    func didToggleTaskCompletion(at index: Int) {
        let task = self.actualTasks[index]
        self.interactor?.toggleTaskCompletion(task)
    }
    
    func didDeleteTask(at index: Int) {
        let task = self.actualTasks[index]
        self.interactor?.deleteTask(task)
    }
    
    func searchTasks(with query: String) {
        self.isSearching = query.isEmpty == false
        self.updateFilteredTasks(with: query)
        self.view?.showTasks(self.filteredTasks)
        self.view?.updateEmptyState()
    }
}

// MARK: - Interactor Output Protocol
extension TodoListPresenter: TodoListInteractorOutputProtocol {
    func tasksFetched(_ tasks: [TodoTask]) {
        self.set(tasks: tasks)
        
        self.view?.showTasks(self.filteredTasks)
        
        self.view?.hideLoading()
        self.view?.hideRefreshControl()
        
        self.view?.updateEmptyState()
    }
    
    func tasksFetchFailed(_ error: any Error) {
        self.view?.hideLoading()
        self.view?.hideRefreshControl()
        
        self.view?.showError(error.localizedDescription)
        
        self.view?.updateEmptyState()
    }
}
