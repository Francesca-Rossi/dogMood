//
//  Status.swift
//  MyDogState
//
//  Created by Francesca Rossi on 21/12/23.
//

import Foundation
import SwiftUI

struct MoodCheckInfo: Codable, Equatable, Identifiable, Hashable
{
    let id: UUID? //unique
    let date: Date?
    let note: String?
    let dog: Dog?
    var moodDetailList: [MoodDetail]?
    let image: Data?
    
    func toString() -> String
    {
        "{id: \(self.id), date: \(self.date), note: \(self.note), dogID: \(self.dog?.id), dogName: \(self.dog?.name), statusList: \(self.moodDetailList?.count)}"
    }
    
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
    
    func dateToString() -> String?
    {
        self.date?.formatted(date: .long, time: .shortened)
    }
    
}

struct MoodDetail: Codable, Equatable, Identifiable, Hashable
{
    let id: UUID? //unique
    let mood: MoodResult.Mood
    let confidence: Float? //TODO: rename with confidence
    let statusInfo: MoodCheckInfo?
    
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
    
    func getMoodChip() -> Chip
    {
        return  Chip(title:  MoodResult.toString(mood: mood),
                     titleColor: self.getMoodForegroundColor(),
                     bgColor: self.getMoodBackgroundColor())
    }
    
   
}

