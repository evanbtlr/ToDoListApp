//
//  CoreDataManagerProtocol.swift
//  ToDoListApp
//
//  Created by Evan Brother on 03.02.2026.
//

import Foundation
import CoreData

protocol CoreDataManagerProtocol {
    
    // MARK: CRUD Operations
    func fetchAll(completion: @escaping (Result<[TodoItem], Error>) -> Void)
    func fetch(by id: UUID, completion: @escaping (Result<TodoItem?, Error>) -> Void)
    func create(title: String, description: String?, completion: @escaping (Result<TodoItem, Error>) -> Void)
    func update(_ item: TodoItem, title: String?, description: String?, isCompleted: Bool?, completion: @escaping (Result<Void, Error>) -> Void)
    func delete(_ item: TodoItem, completion: @escaping (Result<Void, Error>) -> Void)
    
    // MARK: Search
    func search(with query: String, completion: @escaping (Result<[TodoItem], Error>) -> Void)
    
    // MARK: Bulk Operations
    func deleteAll(completion: @escaping (Result<Void, Error>) -> Void)
}
