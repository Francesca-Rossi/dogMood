//
//  Status.swift
//  MyDogState
//
//  Created by Francesca Rossi on 21/12/23.
//

import Foundation
import SwiftUI

struct EmotionalInfoCheck: Codable, Equatable, Identifiable, Hashable
{
    var id: UUID? //unique
    var date: Date?
    var note: String?
    var dog: Dog?
    var statusList: [MoodDetail]?
    
    func toString() -> String
    {
        "{id: \(self.id), date: \(self.date), note: \(self.note), dogID: \(self.dog?.id), dogName: \(self.dog?.name), statusList: \(self.statusList?.count)}"
    }
    
}

struct MoodDetail: Codable, Equatable, Identifiable, Hashable
{
    let id: UUID? //unique
    let mood: MoodResult.Mood
    let confidence: Double? //TODO: rename with confidence
    let statusInfo: EmotionalInfoCheck?
    
    func getMoodForegroundColor()-> Color
    {
        switch mood
        {
            case .happy, .relaxed, .sad, .angry:
                return .white
            default:
                return .black
        }
    }
    
    func getMoodBackgroundColor()-> Color
    {
        switch mood
        {
            case .happy: return .green
            case .relaxed: return .blue
            case .sad: return .orange
            case .angry: return .red
            default: return .black
        }
    }
}

