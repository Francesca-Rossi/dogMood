//
//  Dog.swift
//  MyDogState
//
//  Created by Francesca Rossi on 11/07/23.
//

import Foundation
import SwiftUI

/// Class for dog info
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
    var emotionalCheckList: [MoodCheckInfo]?
    var isSelected = false

    //MARK: - sex methods
    /**
     - Returns: Background color for UI Chip
     */
    private func getSexBackgroundColor()-> Color
    {
        switch sex
        {
        case sexType.Boy: return .blue
        case sexType.Girl: return .pink
        default:
            return .blue
        }
    }
    
    /**
     - Returns: Foreground color for UI Chip
     */
    private func getSexForegroundColor()-> Color
    {
        switch sex
        {
        case sexType.Boy, sexType.Girl : return .white
        default:
            return .white
        }
    }
    
    /**
     Method for UI
     - Returns: Return a Chip struct that rappresent sex whit title and color
     */
    func getSexChip() -> Chip?
    {
        if let sex = self.sex
        {
            return Chip(title: sex,
                        titleColor: self.getSexForegroundColor(),
                        bgColor: self.getSexBackgroundColor())
        }
        return nil
    }
    
    //MARK: formated methods
    /**
     - Returns: formated only date of birthday without time, like this " October 21, 2015"
     */
    func formatedDateOfBirthday() -> String?
    {
        self.dateOfBirth?.formatted(date: .long, time: .omitted)
    }
    
    /**
     - Returns: All the attributes contains in the class,  formatted by key: value
     */
    func toString() -> String
    {
        "{id: \(self.id), name: \(self.name), microchip: \(self.microchip), sex: \(self.sex) dateOfBirth: \(self.dateOfBirth), date: \(self.date), breed: \(self.breed), hairColor: \(self.hairColor), imageSize: \(self.image?.count), emotionalCheckListSize: \(self.emotionalCheckList?.count)}"
    }
}
