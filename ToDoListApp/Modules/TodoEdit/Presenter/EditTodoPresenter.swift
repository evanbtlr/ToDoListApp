//
//  EditTodoPresenter.swift
//  ToDoListApp
//
//  Created by Evan Brother on 04.02.2026.
//

import Foundation

final class EditTodoPresenter {
    
    // MARK: Properties
    weak var view: EditTodoViewProtocol?
    var interactor: EditTodoInteractorProtocol?
    var router: EditTodoRouterProtocol?
    
    private var data: EditTodoData
    private var originalData: EditTodoData
    
    // MARK: Initialization
    init(data: EditTodoData = EditTodoData()) {
        self.data = data
        self.originalData = data
    }
    
    // MARK: Private Methods
    private func hasChanges() -> Bool {
        return self.data.title != self.originalData.title || self.data.description != self.originalData.description || self.data.isCompleted != self.originalData.isCompleted
    }
    
    private func validateAndSave() {
        guard self.data.isValid else {
            self.view?.showValidationError(data.validationErrorMessage ?? "Invalid data")
            return
        }
        
        self.view?.showLoading()
        
        if self.data.id == nil {
            // Create new task
            self.interactor?.save(self.data) { [weak self] result in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.view?.hideLoading()
                    
                    switch result {
                    case .success:
                        self.router?.closeModuleWithRefresh()
                        
                    case .failure(let error):
                        self.view?.showError(error.localizedDescription)
                    }
                }
            }
        } else {
            // Update existing task
            self.interactor?.update(self.data) { [weak self] result in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.view?.hideLoading()
                    
                    switch result {
                    case .success:
                        self.router?.closeModuleWithRefresh()
                        
                    case .failure(let error):
                        self.view?.showError(error.localizedDescription)
                    }
                }
            }
        }
    }
}

// MARK: - EditTodoPresenterProtocol
extension EditTodoPresenter: EditTodoPresenterProtocol {
    func viewDidLoad() {
        self.view?.showData(self.data)
    }
    
    func didTapSaveButton(title: String, description: String?, isCompleted: Bool) {
        self.data.title = title
        self.data.description = description
        self.data.isCompleted = isCompleted
        
        self.validateAndSave()
    }
    
    func didTapCancelButton() {
        if self.hasChanges() {
            // Show confirmation alert
            self.showCancelConfirmation()
        } else {
            self.router?.closeModule(animated: true)
        }
    }
    
    func didUpdateTitle(_ text: String) {
        self.data.title = text
        self.view?.clearValidationError()
    }
    
    func didUpdateDescription(_ text: String) {
        self.data.description = text.isEmpty ? nil : text
    }
    
    // MARK: Private Helper
    private func showCancelConfirmation() {
        // In a real app, you would show an alert here
        // For simplicity, we'll just close
        self.router?.closeModule(animated: true)
    }
}
