//
//  StringUtilities.swift
//  MyDogState
//
//  Created by Francesca Rossi on 26/12/23.
//

import Foundation

public class StringUtilities
{
    static var emptyString: String
    {
        return ""
    }
    
    static func equals(str1: String?, str2: String?)-> Bool
    {
            return str1 == str2
    }
    
    static func convertToPercentual(float: Float) -> String
    {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        guard let number =  numberFormatter.string(from: NSNumber(value: float)) else { fatalError("Can not get number") }
        return number
    }
}

extension String
{
    func isEqual(other: String) -> Bool
    {
        return self == other
    }
    
    var isEmpty: Bool
    {
        self == StringUtilities.emptyString
    }
}
