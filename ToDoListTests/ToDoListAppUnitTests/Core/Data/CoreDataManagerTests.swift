//
//  CoreDataManagerTests.swift
//  ToDoListApp
//
//  Created by Evan Brother on 04.02.2026.
//

import XCTest
import CoreData

@testable import ToDoListApp

final class CoreDataManagerTests: XCTestCase {
    
    // MARK: - Properties
    var coreDataManager: CoreDataManager!
    var testCoreDataStack: CoreDataStack!
    
    // MARK: - Setup & Teardown
    override func setUp() {
        super.setUp()
        
        self.testCoreDataStack = CoreDataStack(inMemory: true)
        self.coreDataManager = CoreDataManager(stack: testCoreDataStack)
    }
    
    override func tearDown() {
        self.coreDataManager = nil
        self.testCoreDataStack = nil
        
        super.tearDown()
    }
    
    // MARK: - Test Cases
    
    func testCreateTodo() {
        // Given
        let expectation = self.expectation(description: "Create todo")
        let title = "Test Task"
        let description = "Test Description"
        
        // When
        self.coreDataManager.create(title: title, description: description) { result in
            // Then
            switch result {
            case .success(let todoItem):
                XCTAssertEqual(todoItem.title, title)
                XCTAssertEqual(todoItem.desc, description)
                XCTAssertFalse(todoItem.isCompleted)
                XCTAssertNotNil(todoItem.id)
                XCTAssertNotNil(todoItem.createdDate)
                
            case .failure(let error):
                XCTFail("Failed to create todo: \(error)")
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchAllTodos() {
        // Given
        let expectation = self.expectation(description: "Fetch all todos")
        
        self.createTestTodoItems(count: 3)
        
        // When
        self.coreDataManager.fetchAll { result in
            // Then
            switch result {
            case .success(let todos):
                XCTAssertEqual(todos.count, 3)
                
            case .failure(let error):
                XCTFail("Failed to fetch todos: \(error)")
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testUpdateTodo() {
        // Given
        let expectation = self.expectation(description: "Update todo")
        let newTitle = "Updated Title"
        let newDescription = "Updated Description"
        
        self.coreDataManager.create(title: "Original", description: "Original") { [weak self] result in
            guard let self = self else { return }
            
            guard case .success(let todoItem) = result, let todoItemId = todoItem.id else {
                XCTFail("Failed to create todo")
                
                expectation.fulfill()
                
                return
            }
            
            // When
            self.coreDataManager.update(
                todoItem,
                title: newTitle,
                description: newDescription,
                isCompleted: true
            ) { updateResult in
                // Then
                switch updateResult {
                case .success:
                    self.coreDataManager.fetch(by: todoItemId) { fetchResult in
                        switch fetchResult {
                        case .success(let updatedItem):
                            XCTAssertEqual(updatedItem?.title, newTitle)
                            XCTAssertEqual(updatedItem?.desc, newDescription)
                            XCTAssertTrue(updatedItem?.isCompleted ?? false)
                            
                        case .failure(let error):
                            XCTFail("Failed to fetch updated todo: \(error)")
                        }
                        
                        expectation.fulfill()
                    }
                case .failure(let error):
                    XCTFail("Failed to update todo: \(error)")
                    
                    expectation.fulfill()
                }
            }
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testDeleteTodo() {
        // Given
        let expectation = self.expectation(description: "Delete todo")
        
        self.coreDataManager.create(title: "To Delete", description: nil) { [weak self] result in
            guard let self = self else { return }
            
            guard case .success(let todoItem) = result, let todoItemId = todoItem.id else {
                XCTFail("Failed to create todo")
                expectation.fulfill()
                return
            }
            
            // When
            self.coreDataManager.delete(todoItem) { deleteResult in
                // Then
                switch deleteResult {
                case .success:
                    // Проверяем что удалилось
                    self.coreDataManager.fetch(by: todoItemId) { fetchResult in
                        switch fetchResult {
                        case .success(let deletedItem):
                            XCTAssertNil(deletedItem)
                            
                        case .failure(let error):
                            XCTFail("Failed to fetch deleted todo: \(error)")
                        }
                        
                        expectation.fulfill()
                    }
                    
                case .failure(let error):
                    XCTFail("Failed to delete todo: \(error)")
                    
                    expectation.fulfill()
                }
            }
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSearchTodos() {
        // Given
        let expectation = self.expectation(description: "Search todos")
        
        self.createTestTodoItems(titles: ["Buy groceries", "Go to gym", "Read book"])
        
        // When
        self.coreDataManager.search(with: "groceries") { result in
            // Then
            switch result {
            case .success(let todos):
                XCTAssertEqual(todos.count, 1)
                XCTAssertEqual(todos.first?.title, "Buy groceries")
            case .failure(let error):
                XCTFail("Failed to search todos: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    // MARK: - Helper Methods
    private func createTestTodoItems(count: Int) {
        let context = self.testCoreDataStack.backgroundContext
        
        context.performAndWait {
            for i in 1...count {
                _ = TodoItem.mock(
                    context: context,
                    title: "Task \(i)",
                    description: "Description \(i)"
                )
            }
            try? context.save()
        }
    }
    
    private func createTestTodoItems(titles: [String]) {
        let context = self.testCoreDataStack.backgroundContext
        
        context.performAndWait {
            for title in titles {
                _ = TodoItem.mock(
                    context: context,
                    title: title,
                    description: nil
                )
            }
            try? context.save()
        }
    }
}
