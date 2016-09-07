//
//  Logger.swift
//
//  Copyright (c) 2015-2016 Nike, Inc. (https://www.nike.com)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import UIKit
import Willow

extension LogLevel {
    /// Custom log level for SQL log messages with a bitmask of `1 << 8`.
    public static let SQL = LogLevel(rawValue: 0b00000000_00000000_00000001_00000000)
}

// MARK: -

extension Logger {
    func sql(message: Void -> String) {
        logMessage(message, withLogLevel: .SQL)
    }
}

// MARK: -

/// The single `Logger` instance used throughout Database.
public var log: Logger! = {
    struct PrefixFormatter: Formatter {
        func formatMessage(message: String, logLevel: LogLevel) -> String {
            return "[Database] => \(message)"
        }
    }

    let formatters: [LogLevel: [Formatter]] = [.All: [PrefixFormatter(), TimestampFormatter()]]
    let queue = dispatch_queue_create("com.nike.database.logger.queue", DISPATCH_QUEUE_SERIAL)
    let configuration = LoggerConfiguration(formatters: formatters, executionMethod: .Asynchronous(queue: queue))

    return Logger(configuration: configuration)
}()
