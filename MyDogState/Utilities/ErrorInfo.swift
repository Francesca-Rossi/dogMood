//
//  ErrorInfo.swift
//  MyDogState
//
//  Created by Francesca Rossi on 06/07/23.
//

import Foundation
public class ErrorInfo: Error
{
    private var message = ""
    
    public func setErrorMessage(value: String)
    {
        message = value
    }
    
    public func getErrorMessage()->String
    {
        return message
    }
    
    public func hasErrorInfo() -> Bool
    {
        if !message.isEmpty
        {
            return true
        }
        return false
    }
    
    public func isAllOK() -> Bool
    {
        hasErrorInfo() == false
    }
}
