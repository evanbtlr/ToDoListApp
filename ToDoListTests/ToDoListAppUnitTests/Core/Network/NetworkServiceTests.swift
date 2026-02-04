//
//  NetworkServiceTests.swift
//  ToDoListApp
//
//  Created by Evan Brother on 04.02.2026.
//

import XCTest
@testable import ToDoListApp

final class NetworkServiceTests: XCTestCase {
    
    // MARK: - Properties
    var networkService: NetworkService!
    var mockSession: MockURLSession!
    
    // MARK: - Setup & Teardown
    override func setUp() {
        super.setUp()
        
        self.mockSession = MockURLSession()
        self.networkService = NetworkService(session: mockSession)
    }
    
    override func tearDown() {
        self.networkService = nil
        self.mockSession = nil
        
        super.tearDown()
    }
    
    // MARK: - Test Cases
    
    func testFetchInitialTodosSuccess() {
        // Given
        let expectation = self.expectation(description: "Fetch todos success")
        let mockData = """
        {
            "todos": [
                {"id": 1, "todo": "Test Task 1", "completed": false, "userId": 1},
                {"id": 2, "todo": "Test Task 2", "completed": true, "userId": 1}
            ],
            "total": 2,
            "skip": 0,
            "limit": 30
        }
        """.data(using: .utf8)!
        
        let mockResponse = HTTPURLResponse(
            url: URL(string: "https://dummyjson.com/todos")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        self.mockSession.data = mockData
        self.mockSession.response = mockResponse
        
        // When
        self.networkService.fetchInitialTodoItems { result in
            // Then
            switch result {
            case .success(let todos):
                XCTAssertEqual(todos.count, 2)
                XCTAssertEqual(todos[0].id, 1)
                XCTAssertEqual(todos[0].title, "Test Task 1")
                XCTAssertFalse(todos[0].completed)
                XCTAssertEqual(todos[1].id, 2)
                XCTAssertEqual(todos[1].title, "Test Task 2")
                XCTAssertTrue(todos[1].completed)
                
            case .failure(let error):
                XCTFail("Expected success but got error: \(error)")
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchInitialTodosNetworkError() {
        // Given
        let expectation = self.expectation(description: "Fetch todos network error")
        let mockError = NSError(domain: "NSURLErrorDomain", code: NSURLErrorNotConnectedToInternet, userInfo: nil)
        
        self.mockSession.error = mockError
        
        // When
        self.networkService.fetchInitialTodoItems { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
                
            case .failure(let error):
                if let networkError = error as? NetworkError {
                    XCTAssertEqual(networkError.errorDescription, "No internet connection")
                } else {
                    XCTFail("Expected NetworkError but got: \(error)")
                }
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchInitialTodosInvalidResponse() {
        // Given
        let expectation = self.expectation(description: "Fetch todos invalid response")
        
        let mockResponse = HTTPURLResponse(
            url: URL(string: "https://dummyjson.com/todos")!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )
        
        self.mockSession.response = mockResponse
        
        // When
        self.networkService.fetchInitialTodoItems { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
                
            case .failure(let error):
                if let networkError = error as? NetworkError {
                    XCTAssertEqual(networkError.errorDescription, "Server error: 500")
                } else {
                    XCTFail("Expected NetworkError but got: \(error)")
                }
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchInitialTodosInvalidJSON() {
        // Given
        let expectation = self.expectation(description: "Fetch todos invalid JSON")
        let invalidData = "invalid json".data(using: .utf8)!
        
        let mockResponse = HTTPURLResponse(
            url: URL(string: "https://dummyjson.com/todos")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        self.mockSession.data = invalidData
        self.mockSession.response = mockResponse
        
        // When
        self.networkService.fetchInitialTodoItems { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
                
            case .failure(let error):
                XCTAssertTrue(error is DecodingError || error is NetworkError)
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
