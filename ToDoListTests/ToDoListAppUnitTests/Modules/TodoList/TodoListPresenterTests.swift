//
//  TodoListPresenterTests.swift
//  ToDoListApp
//
//  Created by Evan Brother on 04.02.2026.
//

import XCTest
@testable import ToDoListApp

final class TodoListPresenterTests: XCTestCase {
    
    // MARK: Properties
    var presenter: TodoListPresenter!
    var mockView: MockTodoListView!
    var mockInteractor: MockTodoListInteractor!
    var mockRouter: MockTodoListRouter!
    
    // MARK: Setup & Teardown
    override func setUp() {
        super.setUp()
        
        self.mockView = MockTodoListView()
        self.mockInteractor = MockTodoListInteractor()
        self.mockRouter = MockTodoListRouter()
        
        self.presenter = TodoListPresenter()
        self.presenter.view = self.mockView
        self.presenter.interactor = self.mockInteractor
        self.presenter.router = self.mockRouter
    }
    
    override func tearDown() {
        self.presenter = nil
        self.mockView = nil
        self.mockInteractor = nil
        self.mockRouter = nil
        
        super.tearDown()
    }
    
    // MARK: Test Cases
    
    func testViewDidLoad() {
        // When
        self.presenter.viewDidLoad()
        
        // Then
        XCTAssertTrue(self.mockView.showLoadingCalled)
        XCTAssertTrue(self.mockInteractor.fetchTasksCalled)
    }
    
    func testDidTapAddButton() {
        // When
        self.presenter.didTapAddButton()
        
        // Then
        XCTAssertTrue(self.mockRouter.navigateToAddTaskCalled)
    }
    
    func testDidSelectTask() {
        // Given
        let testTask: TodoTask = .mock()
        self.presenter.set(tasks: [testTask])
        
        // When
        self.presenter.didSelectTask(at: 0)
        
        // Then
        XCTAssertTrue(self.mockRouter.navigateToEditTaskCalled)
        XCTAssertEqual(self.mockRouter.taskToEdit?.id, testTask.id)
    }
    
    func testDidToggleTaskCompletion() {
        // Given
        let testTask: TodoTask = .mock()
        self.presenter.set(tasks: [testTask])
        
        // When
        self.presenter.didToggleTaskCompletion(at: 0)
        
        // Then
        XCTAssertTrue(self.mockInteractor.toggleTaskCompletionCalled)
        XCTAssertEqual(self.mockInteractor.toggleTask?.id, testTask.id)
    }
    
    func testDidDeleteTask() {
        // Given
        let testTask = TodoTask.mock()
        self.presenter.set(tasks: [testTask])
        
        // When
        self.presenter.didDeleteTask(at: 0)
        
        // Then
        XCTAssertTrue(self.mockInteractor.deleteTaskCalled)
        XCTAssertEqual(self.mockInteractor.deleteTask?.id, testTask.id)
    }
    
    func testSearchTasksEmptyQuery() {
        // Given
        let testTasks: [TodoTask] = [
            .mock(title: "Task 1"),
            .mock(title: "Task 2")
        ]
        
        self.presenter.set(tasks: testTasks)
        
        // When
        self.presenter.searchTasks(with: "")
        
        // Then
        XCTAssertEqual(self.presenter.allTasks.count, 2)
        XCTAssertEqual(self.mockView.tasksShown.count, 2)
        
        XCTAssertTrue(self.mockView.showTasksCalled)
    }
    
    func testSearchTasksWithQuery() {
        // Given
        let query = "test"
        
        let testTasks: [TodoTask] = [
            .mock(title: "Task 1", description: "Test"),
            .mock(title: "Task 2", description: "Description")
        ]
        
        self.presenter.set(tasks: testTasks)
        
        // When
        self.presenter.searchTasks(with: query)
        
        // Then
        XCTAssertEqual(self.mockView.tasksShown.count, 1)
        XCTAssertEqual(self.mockView.tasksShown[0].id, testTasks[0].id)
        XCTAssertEqual(self.presenter.allTasks.count, 2)
    }
    
    func testTasksFetched() {
        // Given
        let testTasks: [TodoTask] = [
            .mock(title: "Task 1"),
            .mock(title: "Task 2")
        ]
        
        // When
        self.presenter.tasksFetched(testTasks)
        
        // Then
        XCTAssertTrue(self.mockView.hideLoadingCalled)
        XCTAssertTrue(self.mockView.hideRefreshControlCalled)
        XCTAssertTrue(self.mockView.showTasksCalled)
        
        XCTAssertEqual(self.mockView.tasksShown.count, 2)
        XCTAssertEqual(self.presenter.allTasks.count, 2)
    }
    
    func testTasksFetchFailed() {
        // Given
        let error = NSError(domain: "Test", code: 1, userInfo: nil)
        
        // When
        self.presenter.tasksFetchFailed(error)
        
        // Then
        XCTAssertTrue(self.mockView.hideLoadingCalled)
        XCTAssertTrue(self.mockView.hideRefreshControlCalled)
        XCTAssertTrue(self.mockView.showErrorCalled)
        XCTAssertNotNil(self.mockView.errorShown)
    }
}
