//
//  TodoListUITests.swift
//  ToDoListApp
//
//  Created by Evan Brother on 04.02.2026.
//

import XCTest

final class TodoListUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        self.continueAfterFailure = false
        self.app = XCUIApplication()
        
        // Reset the application state before each test
        self.app.launchArguments.append("--uitesting")
        self.app.launch()
    }
    
    override func tearDown() {
        self.app = nil
        
        super.tearDown()
    }
    
    func testAppLaunch() {
        XCTAssertTrue(self.app.waitForExistence(timeout: 5))
        
        XCTAssertTrue(self.app.navigationBars["ToDo List"].exists)
        XCTAssertTrue(self.app.buttons["Add"].exists)
    }
    
    func testAddNewTask() {
        let title = "Test UI Task"
        
        self.app.buttons["Add"].tap()
        
        XCTAssertTrue(self.app.navigationBars["New Task"].exists)
        
        let titleTextField = self.app.textFields["Enter task title"]
        
        XCTAssertTrue(titleTextField.waitForExistence(timeout: 2))
        
        titleTextField.tap()
        titleTextField.typeText(title)
        
        let descriptionTextView = self.app.textViews.firstMatch
        
        descriptionTextView.tap()
        descriptionTextView.typeText("This is a test task from UI tests")
        
        self.app.buttons["Save"].tap()
        
        XCTAssertTrue(self.app.navigationBars["ToDo List"].waitForExistence(timeout: 2))
        
        XCTAssertTrue(self.app.staticTexts[title].exists)
        
        self.deleteTestTask(title: title)
        
        XCTAssertFalse(self.app.staticTexts[title].exists)
    }
    
    func testDeleteTask() {
        // Добавляем задачу
        self.addTestTask(title: "Delete me")
        
        // Свайпаем задачу влево
        let taskCell = self.app.staticTexts["Delete me"].firstMatch
        taskCell.swipeLeft()
        
        // Нажимаем Delete
        self.app.buttons["Delete"].tap()
        
        // Проверяем что задача удалилась
        XCTAssertFalse(taskCell.exists)
    }
    
    func testSearchTasks() {
        let testTask1 = "Buy groceries"
        let testTask2 = "Go to gym"
        
        self.addTestTask(title: testTask1)
        self.addTestTask(title: testTask2)
        
        XCTAssertTrue(self.app.staticTexts[testTask1].exists)
        XCTAssertTrue(self.app.staticTexts[testTask2].exists)
        
        // Нажимаем на поле поиска
        let searchField = self.app.searchFields["Search tasks ..."]
        XCTAssertTrue(searchField.waitForExistence(timeout: 2))
        searchField.tap()
        
        // Ищем "groceries"
        searchField.typeText("groceries")
        
        // Проверяем что только одна задача отображается
        XCTAssertTrue(self.app.staticTexts[testTask1].exists)
        XCTAssertFalse(self.app.staticTexts[testTask2].exists)
        
        let clearButton = searchField.buttons["Clear text"]
        XCTAssertTrue(clearButton.waitForExistence(timeout: 5))
        clearButton.tap()
        
        self.deleteTestTask(title: testTask1)
        self.deleteTestTask(title: testTask2)
        
        XCTAssertFalse(self.app.staticTexts[testTask1].exists)
        XCTAssertFalse(self.app.staticTexts[testTask2].exists)
    }
    
    func testToggleTaskCompletion() {
        // Добавляем задачу
        let title = "Complete me"
        self.addTestTask(title: "Complete me")
        
        // Находим switch задачи
        let taskSwitch = self.app.switches.element(boundBy: 0)
        
        // Проверяем начальное состояние
        XCTAssertEqual(taskSwitch.value as? String, "0") // 0 = выключен
        
        // Включаем
        taskSwitch.tap()
        
        // Проверяем что включился
        XCTAssertEqual(taskSwitch.value as? String, "1") // 1 = включен
        
        self.deleteTestTask(title: title)
        
        XCTAssertFalse(self.app.staticTexts[title].exists)
    }
    
    // MARK: Helper Methods
    private func addTestTask(title: String) {
        self.app.buttons["Add"].tap()
        
        let titleTextField = self.app.textFields["Enter task title"]
        titleTextField.tap()
        titleTextField.typeText(title)
        
        self.app.buttons["Save"].tap()
    }
    
    private func deleteTestTask(title: String) {
        let taskCell = self.app.staticTexts[title].firstMatch
        taskCell.swipeLeft()
        
        // Нажимаем Delete
        self.app.buttons["Delete"].tap()
    }
}
