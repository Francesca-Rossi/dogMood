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
    
    func toString() -> String
    {
        "{id: \(self.id), date: \(self.date), note: \(self.note), dogID: \(self.dog?.id), dogName: \(self.dog?.name), statusList: \(self.statusList?.count)}"
    }
    
}

struct EmotionalState: Codable, Equatable, Identifiable, Hashable
{
    let id: UUID? //unique
    let state: String?
    let percentual: Double?
    let statusInfo: EmotionalInfoCheck?
}

