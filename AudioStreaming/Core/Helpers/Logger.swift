//
//  Created by Dimitrios Chatzieleftheriou on 28/07/2020.
//  Copyright © 2020 Decimal. All rights reserved.
//

import Foundation
import os
import OSLog

private let loggingSubsystem = "audio.streaming.log"

enum Logger {
    private static let audioRendering = os.Logger(subsystem: loggingSubsystem, category: "audio.rendering")
    private static let networking =  os.Logger(subsystem: loggingSubsystem, category: "audio.networking")
    private static let generic =  os.Logger(subsystem: loggingSubsystem, category: "audio.streaming.generic")

    /// Defines is the the logger displays any logs
    static var isEnabled = true

    enum Category: CaseIterable {
        case audioRendering
        case networking
        case generic

        func toOSLog() -> os.Logger {
            switch self {
            case .audioRendering: return Logger.audioRendering
            case .networking: return Logger.networking
            case .generic: return Logger.generic
            }
        }
    }

    static func error(_ message: String, category: Category, args: CVarArg..., file: String = #file, function: String = #function, line: Int = #line) {
        log(String(format: message, args), category: category, severity: "🟥 ERROR", file: file, function: function, line: line)
    }

    static func error(_ message: String, category: Category, file: String = #file, function: String = #function, line: Int = #line) {
        error(message, category: category, args: [], file: file, function: function, line: line)
    }

    static func debug(_ message: String, category: Category, args: CVarArg..., file: String = #file, function: String = #function, line: Int = #line) {
        log(String(format: message, args), category: category, severity: "▶️ DEBUG", file: file, function: function, line: line)
    }

    static func debug(_ message: String, category: Category, file: String = #file, function: String = #function, line: Int = #line) {
        debug(message, category: category, args: [], file: file, function: function, line: line)
    }

    static private func log(_ message: String, category: Category, severity: String, file: String, function: String, line: Int) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        category.toOSLog().debug("\(formatter.string(from: Date())) \(severity) \(fileNameWithoutSuffix(file)).\(stripParams(function)):\(line) - \(message)")
    }

    static func stripParams(_ function: String) -> String {
        var f = function
        if let indexOfBrace = f.firstIndex(of: "(") {
            f = String(f[..<indexOfBrace])
        }
        f += "()"
        return f
    }

    static func fileNameOfFile(_ file: String) -> String {
        let fileParts = file.components(separatedBy: "/")
        if let lastPart = fileParts.last {
            return lastPart
        }
        return ""
    }

    static func fileNameWithoutSuffix(_ file: String) -> String {
        let fileName = fileNameOfFile(file)

        if !fileName.isEmpty {
            let fileNameParts = fileName.components(separatedBy: ".")
            if let firstPart = fileNameParts.first {
                return firstPart
            }
        }
        return ""
    }
}
