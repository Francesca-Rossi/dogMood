//
//  Dog.swift
//  MyDogState
//
//  Created by Francesca Rossi on 11/07/23.
//

import Foundation
import SwiftUI

struct Dog: Codable, Equatable, Identifiable, Hashable
{
    let id: UUID? //unique
    let name: String?
    let microchip: String?
    let dateOfBirth: Date?
    let image: Data?
    let breed: String?
    let sex: String?
    let hairColor: String?
    let date: Date? //insert date
    var isSelected = false

    func getSexColor()-> Color
    {
        switch sex
        {
        case sexType.Boy: return .blue
        case sexType.Girl: return .pink
        default:
            return .blue
        }
        
    }
}
