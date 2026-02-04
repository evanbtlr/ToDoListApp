//
//  Logger.swift
//  ToDoListApp
//
//  Created by Evan Brother on 05.02.2026.
//

import Foundation

enum LogLevel: String {
    case debug = "DEBUG"
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"
    case fatal = "FATAL"
}

final class Logger {
    
    static var isEnabled: Bool = true
    
    static func log(_ level: LogLevel, _ message: String, file: String = #file, line: Int = #line, function: String = #function) {
        guard isEnabled else { return }
        
        let fileName = (file as NSString).lastPathComponent
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        
        print("[\(timestamp)] \(level.rawValue) [\(fileName):\(line)] \(function) - \(message)")
    }
    
    static func debug(_ message: String, file: String = #file, line: Int = #line, function: String = #function) {
        self.log(.debug, message, file: file, line: line, function: function)
    }
    
    static func info(_ message: String, file: String = #file, line: Int = #line, function: String = #function) {
        self.log(.info, message, file: file, line: line, function: function)
    }
    
    static func warning(_ message: String, file: String = #file, line: Int = #line, function: String = #function) {
        self.log(.warning, message, file: file, line: line, function: function)
    }
    
    static func error(_ message: String, file: String = #file, line: Int = #line, function: String = #function) {
        self.log(.error, message, file: file, line: line, function: function)
    }
}
