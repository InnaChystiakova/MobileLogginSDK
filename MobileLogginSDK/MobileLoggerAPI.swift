//
//  MobileLoggingManagerAPI.swift
//  MobileLogginSDK
//
//  Created by Inna Chystiakova on 07/09/2024.
//

import Foundation
///
/// enum`MobileLoggerResult`
///
/// This enum describes the result of public logging methods.
///
/// `-success` if message was posted successfylly (can return description optionally)
/// `-error` if message was not posted return the error description
///
@frozen
public enum MobileLoggerResult: Equatable {
    case success(String?)
    case failure(String)
}

///
/// class `MobileLogger`
///
/// This class describes the basic access to the logging API
/// Use MobileLoggingManager() to access all the basic functions
///
public class MobileLogger {
    private let manager: MobileLoggingManager
    
    public init() {
        self.manager = MobileLoggingManager()
    }
}
///
/// extension `MobileLogger`
///
/// This extension contains all the public methods for posting messages
///
public extension MobileLogger {
    ///
    /// Function allows to post a message to the backend.
    /// 
    /// Parameters:
    /// `-string: String` - message to post
    /// `-completion: @escaping (MobileLoggingManagerResult) -> Void` - callback with the result if massage was posted or not
    ///
    func logMessage(string: String, completion: @escaping (MobileLoggerResult) -> Void) {
        manager.post(body: [.myString : string], completion: completion)
    }
    ///
    /// Function allows to post a several messages to the backend.
    ///
    /// !!! Important caution!!!
    /// Only messages with the proper JSON keys will be posted.
    /// You can use only "myString" key at this API version
    ///
    /// Parameters:
    /// `-dictionary: [String: String]` - message to post
    /// `-completion: @escaping (MobileLoggingManagerResult) -> Void` - callback with the result if massage was posted or not
    ///
    func logListOfMessages(from dictionary: [String: String], completion: @escaping (MobileLoggerResult) -> Void) {
        let convertedDictionary = manager.convert(dictionary: dictionary)
        manager.post(body: convertedDictionary, completion: completion)
    }
    ///
    /// Function allows to post a message constructed from an array of strings
    ///
    /// ! Important caution!
    /// All the messages will be joined to one string with the following separator "<>"
    ///
    /// Parameters:
    /// `-strings: [String]` - array of strings wich will be joined into one long message
    /// `-completion: @escaping (MobileLoggingManagerResult) -> Void` - callback with the result if massage was posted or not
    ///
    func logMultipleMessages(strings: [String], completion: @escaping (MobileLoggerResult) -> Void) {
        if strings.isEmpty {
            completion(.failure("Array is empty"))
        }
        let commonString = strings.joined(separator: "<>")
        manager.post(body: [.myString: commonString], completion: completion)
    }
    ///
    /// Function allows to post a message of defined length
    ///
    /// If you want to define the minimun, maximum or both extremums of the message, you can use minLen and maxLen parameters
    ///
    /// Parameters:
    /// `-string: String` - message to post
    /// `-minLen: Int = 1`- minimum length of the message, default value is 1
    /// `-maxLen: Int = 1000` - maximum length of the message, default value is 1000
    /// `-completion: @escaping (MobileLoggingManagerResult) -> Void` - callback with the result if massage was posted or not
    ///
    func logMessageIfValid(
        string: String,
        minLen: Int = 1,
        maxLen: Int = 1000,
        completion: @escaping (MobileLoggerResult) -> Void
    ) {
        manager.postMessageOfValidLength(string: string, minLen: minLen, maxLen: maxLen, completion: completion)
    }
    ///
    /// Function allows to post a message with pre-defined delay
    ///
    /// If you want to define the minimun, maximum or both extremums of the message, you can use minLen and maxLen parameters
    ///
    /// Parameters:
    /// `-string: String` - message to post
    /// `-delay: TimeInterval = 0`- number of delay in seconds, default value is 0 (message will be sent now)
    /// `-completion: @escaping (MobileLoggingManagerResult) -> Void` - callback with the result if massage was posted or not
    ///
    func logMessageWithDelay(string: String, delay: TimeInterval = 0, completion: @escaping (MobileLoggerResult) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
            self.logMessage(string: string, completion: completion)
        }
    }
    ///
    /// Function allows to post a message with pre-defined symbols in regex format
    ///
    /// The format of regex should be in a String enumeration. For example, "[A-Za-z0-9]+" or "^\\d+$"
    ///
    /// Parameters:
    /// `-string: String` - message to post
    /// `-regex: String`- define your regex to validate the message
    /// `-completion: @escaping (MobileLoggingManagerResult) -> Void` - callback with the result if massage was posted or not
    ///
    func logMessageIfValidFormat(string: String, regex: String, completion: @escaping (MobileLoggerResult) -> Void) {
        manager.postMessageIfValidFormat(string: string, regex: regex, completion: completion)
    }
    ///
    /// Function allows to get the curl format of the request for logging message.
    /// MobileLoggerResult.success will return the curl in a String format
    /// It doesn't post a message. Just get the curl string.
    ///
    /// Parameters:
    /// `-string: String` - message
    /// `-completion: @escaping (MobileLoggingManagerResult) -> Void` - callback with the result
    ///
    func getLogCurlCommand(for message: String, completion: (MobileLoggerResult) -> Void) {
        manager.generatePostRequestCurlCommand(for: message, completion: completion)
    }
}
