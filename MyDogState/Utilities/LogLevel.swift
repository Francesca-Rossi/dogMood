//
//  LogLevel.swift
//  MyDogState
//
//  Created by Francesca Rossi on 26/12/23.
//
import Foundation

public enum LogLevel: Int, CustomStringConvertible {
    
    case Trace = 0
    case Debug = 1
    case Info = 2
    case Warning = 3
    case Error = 4
    case Fatal = 5
    
    /// Converts a string to a log level if possible.
    /// This initializer is not case sensitive
    public init?(_ stringValue: String) {
        switch(stringValue.lowercased()) {
        case LogLevel.Trace.description.lowercased():
            self = .Trace
        case LogLevel.Debug.description.lowercased():
            self = .Debug
        case LogLevel.Info.description.lowercased():
            self = .Info
        case LogLevel.Warning.description.lowercased():
            self = .Warning
        case LogLevel.Error.description.lowercased():
            self = .Error
        case LogLevel.Fatal.description.lowercased():
            self = .Fatal
        default:
            return nil
        }
    }
    
    /// Returns a human readable representation of the log level.
    public var description : String {
        get {
            switch(self) {
            case .Trace:
                return "TRACE"
            case .Debug:
                return "DEBUG"
            case .Info:
                return "INFO"
            case .Warning:
                return "WARNING"
            case .Error:
                return "ERROR"
            case .Fatal:
                return "FATAL"
            }
        }
    }
}
