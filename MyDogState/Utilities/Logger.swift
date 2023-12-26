//
//  Logger.swift
//  MyDogState
//
//  Created by Francesca Rossi on 26/12/23.
//

import Foundation
import OSLog

class Logger {
    static let shared = Logger()
    
    private init(){FileManager.default.clearTmpDirectory()} //Always start with file empty
    private var fullMessage = StringUtilities.emptyString
    
    func log(
        _ message: Any,
        extra1: String = #file,
        extra2: String = #function,
        extra3: Int = #line,
        level: LogLevel = LogLevel.Debug,
        saveToFile: Bool = false
    ) {
        let filename = (extra1 as NSString).lastPathComponent
        fullMessage = "\r\n\(Date()) - [\(level.description)] - \(filename) - \(extra2) - line \(extra3): \(message)"
        
        //Always show in the console if is DEBUG level
        if level == LogLevel.Debug
        {
            print(fullMessage)
        }
        
        // if remoteLog is true record the log in file
        if saveToFile {
            writeTempFile(fullMessage)
        }
        else if (level != LogLevel.Debug) //show in the Log console
        {
            print(fullMessage)
        }
    }
    
    /// pretty print
    func prettyPrint(_ message: Any) {
        dump(message)
    }
    
    func printDocumentsDirectory() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print("Document Path: \(documentsPath)")
    }
    
    func writeTempFile(_ string: String) -> URL
    {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("Log")
            .appendingPathExtension("txt")
        if let fileHandle =  try? FileHandle(forWritingTo: url)
        {
            fileHandle.seekToEndOfFile()
            fileHandle.write(string.data(using: .utf8)!)
            fileHandle.closeFile()
        }
        else
        {
            try? string.write(to: url, atomically: true, encoding: .utf8)
        }
        return url
    }
}

extension FileManager {
    func clearTmpDirectory() {
        do {
            let tmpDirURL = FileManager.default.temporaryDirectory
            let tmpDirectory = try contentsOfDirectory(atPath: tmpDirURL.path)
            try tmpDirectory.forEach { file in
                let fileUrl = tmpDirURL.appendingPathComponent(file)
                try removeItem(atPath: fileUrl.path)
            }
        } catch {
            //catch the error somehow
        }
    }
}
