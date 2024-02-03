//
//  Status.swift
//  MyDogState
//
//  Created by Francesca Rossi on 21/12/23.
//

import Foundation
import SwiftUI

/// Class for the check info
struct MoodCheckInfo: Codable, Equatable, Identifiable, Hashable
{
    let id: UUID? //unique
    let date: Date?
    let note: String?
    let dog: Dog?
    var moodDetailList: [MoodDetail]?
    let image: Data?
   
    /**
        Scroll throw the details list and get out the mood  that has the best confidence score
     - Returns: mood that has the best confidence score
     */
    func getTheBestConfidenceMood() -> MoodDetail?
    {
        if let moodList = self.moodDetailList
        {
            return moodList.max {
                ($0.confidence) ?? 0 < ($1.confidence) ?? 0
            }
        }
        return  nil
    }
    
    /**
     - Returns: list contains the value and confidence of the moodDetail list
     */
    func convertToPredictions() -> [PredictionResult]
    {
        var predictions = [PredictionResult]()
        if let details = self.moodDetailList
        {
            for detail in details
            {
                if let confidence = detail.confidence
                {
                    predictions.append(PredictionResult(confidence: confidence, identifier: MoodResult.toString(mood: detail.mood)))
                }
            }
        }
        return predictions
    }
    
    //MARK: - formated methods
    /**
     - Returns: formated  check date, like this " October 21, 2015 16:29"
     */
    func dateToString() -> String?
    {
        self.date?.formatted(date: .long, time: .shortened)
    }
  
    /**
     - Returns: All the attributes contains in the class,  formatted by key: value
     */
    func toString() -> String
    {
        "{id: \(self.id), date: \(self.date), note: \(self.note), dogID: \(self.dog?.id), dogName: \(self.dog?.name), statusList: \(self.moodDetailList?.count)}"
    }
}

/// Class for the detail of a single mood
struct MoodDetail: Codable, Equatable, Identifiable, Hashable
{
    let id: UUID? //unique
    let mood: MoodResult.Mood
    let confidence: Float?
    let statusInfo: MoodCheckInfo?
    
    /**
    Method for UI
     - Returns: Return the  foreground color of the chio
     */
    private func getMoodForegroundColor()-> Color
    {
        switch mood
        {
            case .happy, .relaxed, .sad, .angry:
                return .white
            default:
                return .black
        }
    }
    
    /**
     Method for UI
     - Returns: Return the  background color of the chio
     */
    private func getMoodBackgroundColor()-> Color
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
   
    /**
     Method for UI
     - Returns: Return a Chip struct that rappresent mood whit title and color
     */
    func getMoodChip() -> Chip
    {
        return Chip(
            title:  MoodResult.toString(mood: mood),
            titleColor: self.getMoodForegroundColor(),
            bgColor: self.getMoodBackgroundColor())
    }
    
}

