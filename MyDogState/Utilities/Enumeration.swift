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
    static let Boy = String(localized: "Male")
    static let Girl = String(localized: "Female")
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
    private static var HAPPY_MOOD = String(localized: "Happy")
    private static var RELAXED_MOOD = String(localized: "Relaxed")
    private static var SAD_MOOD = String(localized: "Sad")
    private static var ANGRY_MOOD = String(localized: "Angry")
    private static var UNKNOWN_MOOD = String(localized: "Unknown")
    
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
            if lowerValue.isEqual(other: "happy") || lowerValue.isEqual(other: String(localized: "Happy").lowercased())
            {
                return .happy
            }
            else if lowerValue.isEqual(other: "relaxed") || lowerValue.isEqual(other: String(localized: "Relaxed").lowercased())
            {
                return .relaxed
            }
            else if lowerValue.isEqual(other: "sad") || lowerValue.isEqual(other: String(localized: "Sad").lowercased())
            {
                return .sad
            }
            else if lowerValue.isEqual(other: "angry") || lowerValue.isEqual(other: String(localized: "Angry").lowercased())
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



