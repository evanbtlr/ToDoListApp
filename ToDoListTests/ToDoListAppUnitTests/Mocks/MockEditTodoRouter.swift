//
//  Untitled.swift
//  ToDoListApp
//
//  Created by Evan Brother on 04.02.2026.
//

import CoreData
import UIKit

@testable import ToDoListApp

final class MockEditTodoRouter: EditTodoRouterProtocol {
    var viewController: UIViewController?
    var closeModuleCalled = false
    var closeModuleWithRefreshCalled = false
    
    func closeModule(animated: Bool) {
        closeModuleCalled = true
    }
    
    func closeModuleWithRefresh() {
        closeModuleWithRefreshCalled = true
    }
}
