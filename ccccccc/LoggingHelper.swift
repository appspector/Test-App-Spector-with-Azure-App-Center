//
//  LoggingHelper.swift
//  SecuriSafe
//
//  Created by Oliver Gepp on 27.06.18.
//  Copyright © 2018 Securiton. All rights reserved.
//

import Foundation

import AppSpectorSDK

import OSLog

class EventPayload: NSObject, ASCustomEventPayload {
    var category: String!
    var name: String!
    var payload: [AnyHashable: Any]!
}

// Application wide variable
let logger = AppSpectorClass()

extension OSLogType {
    var name: String {
        switch self {
        case .debug: return "🪳 DEBUG"
        case .error: return "🛑 ERROR"
        case .fault: return "🌶 FAULT"
        case .info: return "🕯 INFO"
        case .default: return "🥚 DEFAULT"
        default: return "🔦 HIGHLIGHTED"
        }
    }
}

class AppSpectorClass {
    init() {
        let config = AppSpectorConfig(apiKey: "ios_NmVkNmQ3OTItYTIwNS00NTk2LTkxNTAtNTMwMGEzOGNlM2M3", monitorIDs: [.analytics, .customEvents, .environment, .http, .fileSystem, .logs, .performance, .screenshot, .userdefaults])
        config.metadata = [DeviceNameKey: UIDevice.current.name]

        AppSpector.run(with: config)
    }

    private func logEvent(message: String, file: StaticString, function: StaticString, line: UInt, type: OSLogType = .default) {
        let path = file.withUTF8Buffer {
            String(decoding: $0, as: UTF8.self)
        } as NSString
        let fileName = path.lastPathComponent as String

        let functionName = function.withUTF8Buffer {
            String(decoding: $0, as: UTF8.self)
        } as String

        let payload = EventPayload()
        payload.name = functionName
        payload.category = type.name
        payload.payload = [
            "Triggered at": "\(Date())",
            "From File": "\(fileName):\(line)",
            "Function": "\(functionName)",
            "Message": message,
        ]
        AppSpector.sendCustomEvent(with: payload)
        print(message)
    }

    func debug(_ message: String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        self.logEvent(message: message, file: file, function: function, line: line, type: .debug)
    }

    func error(_ message: String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        self.logEvent(message: message, file: file, function: function, line: line, type: .error)
    }

    func info(_ message: String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        self.logEvent(message: message, file: file, function: function, line: line, type: .info)
    }

    func verbose(_ message: String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        self.logEvent(message: message, file: file, function: function, line: line, type: .default)
    }

    func warning(_ message: String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        self.logEvent(message: message, file: file, function: function, line: line, type: .fault)
    }

    func highlight(_ message: String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        self.logEvent(message: "❤️‍🔥 \(message)", file: file, function: function, line: line, type: OSLogType(42))
    }
}
