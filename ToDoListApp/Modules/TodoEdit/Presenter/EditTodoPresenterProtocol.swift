//
//  EditTodoPresenterProtocol.swift
//  ToDoListApp
//
//  Created by Evan Brother on 04.02.2026.
//

protocol EditTodoPresenterProtocol: AnyObject {
    func viewDidLoad()
    
    func didTapSaveButton(title: String, description: String?, isCompleted: Bool)
    func didTapCancelButton()
    
    func didUpdateTitle(_ text: String)
    func didUpdateDescription(_ text: String)
}
