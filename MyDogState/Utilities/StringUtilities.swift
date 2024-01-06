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
}

extension String
{
    func isEqual(other: String) -> Bool
    {
        return self == other
    }
}
