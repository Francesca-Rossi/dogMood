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
    var statusList: [EmotionalState]?
    
    func toString() -> String
    {
        "{id: \(self.id), date: \(self.date), note: \(self.note), dogID: \(self.dog?.id), dogName: \(self.dog?.name), statusList: \(self.statusList?.count)}"
    }
    
}

struct EmotionalState: Codable, Equatable, Identifiable, Hashable
{
    let id: UUID? //unique
    let mood: String?
    let percentual: Double? //TODO: rename with confidence
    let statusInfo: EmotionalInfoCheck?
    
    func getMoodColor()-> Color
    {
        switch MoodResult.fromString(value: mood)
        {
            case .happy: return .green
            case .relaxed: return .blue
            case .sad: return .orange
            case .angry: return .red
            default: return .black
        }
    }
}

