//
//  Log.swift
//  M46Swift
//
//  Created by David Jobe on 2019-08-29.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import Foundation

enum LogEvent: String {
    case d = "🧐"
    case e = "🔥"
    case i = "💬"
}

class Log {
    
    static var df: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    private static func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
    
    static func error( _ object: Any,
                       fileName: String = #file,
                       line: Int = #line,
                       column: Int = #column,
                       funcName: String = #function) {
        print("ERROR: \(Date().toString()) \(LogEvent.e.rawValue) \(sourceFileName(filePath: fileName)) [line: \(line) column: \(column)] \(funcName) -> \(object)")
    }
    
    static func info( _ object: Any, fileName: String = #file) {
        print("INFO: \(Date().toString()) \(LogEvent.i.rawValue) \(sourceFileName(filePath: fileName)) \(object)")
    }
    
    static func debug( _ object: Any = "",
                       filename: String = #file,
                       funcName: String = #function) {
        #if DEBUG
        print("DEBUG: \(Date().toString()) \(LogEvent.d.rawValue) \(sourceFileName(filePath: filename)) \(funcName) -> \(object)")
        #endif
    }
    
}

private extension Date {
    func toString() -> String {
        return Log.df.string(from: self)
    }
}
