//
//  SwiftyLog.swift
//  SwiftyLog
//
//  Created by Alex Nagy on 28/04/2019.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//

import Foundation

enum LogDateFormatter: String {
    case MM_dd_yyyy_HH_mm_ss_SSS = "MM/dd/yyyy HH:mm:ss:SSS"
    case MM_dd_yyyy_HH_mm_ss = "MM-dd-yyyy HH:mm:ss"
    case E_d_MMM_yyyy_HH_mm_ss_Z = "E, d MMM yyyy HH:mm:ss Z"
    case HH_mm_ss = "HH:mm:ss"
}

struct LogOptions {
    static var dateFormatter = LogDateFormatter.HH_mm_ss
}

struct Log {
    static func stats(_ file: String = #file, function: String = #function, line: Int = #line) -> String {
        let fileString: NSString = NSString(string: file)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = LogOptions.dateFormatter.rawValue
        if Thread.isMainThread {
            return "[M] [⏱ \(dateFormatter.string(from: Foundation.Date()))] [\(fileString.lastPathComponent) -> \(function), line:\(line)] ~>"
        } else {
            return "[!=M] [⏱ \(dateFormatter.string(from: Foundation.Date()))] [\(fileString.lastPathComponent) -> \(function), line:\(line)] ~>"
        }
    }
}

enum log {
    case ln(_: String)
    case success(_: String)
    case warning(_: String)
    case error(_: String)
    case todo(_: String)
    case url(_: String)
    case param(_: Any)
    case token(_: String)
}

postfix operator /

postfix func / (target: log?) {
    guard let target = target else { return }
    
    func log<T>(_ emoji: String, _ object: T) {
        // To enable logs only in Debug mode:
        // 1. Go to Buld Settings -> Other C Flags
        // 2. Enter `-D DEBUG` fot the Debug flag
        // 3. Comment out the `#if #endif` lines
        // 4. Celebrate. Your logs will not print in Release, thus saving on memory
        #if DEBUG
        print(emoji + " " + String(describing: object))
        #endif
    }
    
    switch target {
    case .ln(let line):
        log("✏️", line)
    case .success(let success):
        log("✅", success)
    case .warning(let warning):
        log("⚠️", warning)
    case .error(let error):
        log("🔴", error)
    case .todo(let todo):
        log("👨🏼‍💻", todo)
    case .url(let url):
        log("🌏", url)
    case .param(let param):
        log("〈〉", param)
    case .token(let token):
        log("🔑", token)
    }
}
