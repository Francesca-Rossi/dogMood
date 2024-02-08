//
//  Sex.swift
//  MyDogState
//
//  Created by Francesca Rossi on 04/07/23.
//

import Foundation
import SwiftUI


enum sexType
{
    static let Boy = "Male"
    static let Girl = "Female"
}

struct Chip
{
    var title: String
    var titleColor: Color
    var bgColor: Color
    
}

enum ViewParentType
{
    case dogs, states
}

/***
 MoodResult class
  - Implemented to better interpretation the result
  - Managed also the uppercased and lowercased
 ***/
public class MoodResult
{
    private static var HAPPY_MOOD = "happy"
    private static var RELAXED_MOOD = "relaxed"
    private static var SAD_MOOD = "sad"
    private static var ANGRY_MOOD = "angry"
    private static var UNKNOWN_MOOD = "unknown"
    
    public enum Mood: Codable
    {
        case happy
        case relaxed
        case sad
        case angry
        case unknow
    }
    
    public static func fromString(value: String?)-> MoodResult.Mood
    {
        if let lowerValue = value?.lowercased()
        {
            if lowerValue.isEqual(other: "happy")
            {
                return .happy
            }
            else if lowerValue.isEqual(other: "relaxed")
            {
                return .relaxed
            }
            else if lowerValue.isEqual(other: "sad")
            {
                return .sad
            }
            else if lowerValue.isEqual(other: "angry")
            {
                return .angry
            }
        }
        return .unknow
    }
    
    public static func toString(mood: Mood)-> String
    {
        switch mood
        {
        case .happy:
            return MoodResult.HAPPY_MOOD.capitalized
        case .relaxed:
            return MoodResult.RELAXED_MOOD.capitalized
        case .sad:
            return MoodResult.SAD_MOOD.capitalized
        case .angry:
            return MoodResult.ANGRY_MOOD.capitalized
        case .unknow:
            return MoodResult.UNKNOWN_MOOD.capitalized
        }
    }
}



