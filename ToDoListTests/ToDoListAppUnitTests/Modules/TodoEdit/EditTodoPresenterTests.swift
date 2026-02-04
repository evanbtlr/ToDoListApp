//
//  EditTodoPresenterTests.swift
//  ToDoListApp
//
//  Created by Evan Brother on 04.02.2026.
//

import XCTest
@testable import ToDoListApp

final class EditTodoPresenterTests: XCTestCase {
    
    // MARK: Properties
    var presenter: EditTodoPresenter!
    var mockView: MockEditTodoView!
    var mockInteractor: MockEditTodoInteractor!
    var mockRouter: MockEditTodoRouter!
    
    // MARK: Setup & Teardown
    override func setUp() {
        super.setUp()
        
        self.mockView = MockEditTodoView()
        self.mockInteractor = MockEditTodoInteractor()
        self.mockRouter = MockEditTodoRouter()
        
        self.presenter = EditTodoPresenter(data: EditTodoData())
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
        XCTAssertTrue(self.mockView.showDataCalled)
    }
    
    func testDidTapSaveButtonValidData() {
        // Given
        let title = "Test Task"
        let description = "Test Description"
        
        // When
        self.presenter.didTapSaveButton(
            title: title,
            description: description,
            isCompleted: true
        )
        
        // Then
        XCTAssertTrue(self.mockView.showLoadingCalled)
        XCTAssertTrue(self.mockInteractor.saveTodoCalled)
        
        if let data = self.mockInteractor.savedData {
            XCTAssertEqual(data.title, title)
            XCTAssertEqual(data.description, description)
            XCTAssertTrue(data.isCompleted)
        } else {
            XCTFail("No data saved")
        }
    }
    
    func testDidTapSaveButtonInvalidData() {
        // Given
        let emptyTitle = ""
        
        // When
        self.presenter.didTapSaveButton(
            title: emptyTitle,
            description: nil,
            isCompleted: false
        )
        
        // Then
        XCTAssertTrue(self.mockView.showValidationErrorCalled)
        XCTAssertFalse(self.mockInteractor.saveTodoCalled)
    }
    
    func testDidTapCancelButton() {
        // When
        self.presenter.didTapCancelButton()
        
        // Then
        XCTAssertTrue(self.mockRouter.closeModuleCalled)
    }
}
