//
//  Status.swift
//  MyDogState
//
//  Created by Francesca Rossi on 21/12/23.
//

import Foundation

struct EmotionalInfoCheck: Codable, Equatable, Identifiable, Hashable
{
    var id: UUID? //unique
    var date: Date?
    var note: String?
    var dog: Dog?
    var statusList: [EmotionalState]?
    
}

struct EmotionalState: Codable, Equatable, Identifiable, Hashable
{
    let id: UUID? //unique
    let state: String?
    let percentual: Double?
    let statusInfo: EmotionalInfoCheck?
}

