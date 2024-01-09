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
    var emotionalCheckList: [MoodCheckInfo]?
    var isSelected = false

    func getSexBackgroundColor()-> Color
    {
        switch sex
        {
        case sexType.Boy: return .blue
        case sexType.Girl: return .pink
        default:
            return .blue
        }
    }
    
    func getSexForegroundColor()-> Color
    {
        switch sex
        {
        case sexType.Boy, sexType.Girl : return .white
        default:
            return .white
        }
    }
    
    func toString() -> String
    {
        "{id: \(self.id), name: \(self.name), microchip: \(self.microchip), sex: \(self.sex) dateOfBirth: \(self.dateOfBirth), date: \(self.date), breed: \(self.breed), hairColor: \(self.hairColor), imageSize: \(self.image?.count), emotionalCheckListSize: \(self.emotionalCheckList?.count)}"
    }
    
    func getTheBestConfidenceMood(check: MoodCheckInfo) -> MoodDetail?
    {
        if let moodList = check.moodDetailList
        {
            return moodList.max {
                ($0.confidence) ?? 0 < ($1.confidence) ?? 0
            }
        }
        return  nil
    }
    
    public func getBestMoodList() -> [MoodDetail]
    {
        var bestMoodList = [MoodDetail]()
            //getAllCheckBydog
            //for check get mood list
            if let allDogCheck = self.emotionalCheckList
            {
                //take only the best confidence
                //put the result in the list
                for check in allDogCheck
                {
                    if let mood = self.getTheBestConfidenceMood(check: check)
                    {
                        bestMoodList.append(mood)
                    }
                }
            }
            return bestMoodList
    }
}
