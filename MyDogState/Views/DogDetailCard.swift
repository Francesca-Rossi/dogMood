//
//  DogDetailCard.swift
//  MyDogState
//
//  Created by Francesca Rossi on 08/01/24.
//

import SwiftUI

struct DogDetailCard: View {
    var bestMood: MoodDetail //TODO: calcolalo con il viewModel
    var body: some View {
        VStack
        {
            moodHeader
            moodPhoto
            moodFooter
        }
    }
    
    var moodHeader: some View
    {
        HStack
        {
            let moodChip = Chip(title:  MoodResult.toString(mood: bestMood.mood),
                 titleColor: bestMood.getMoodForegroundColor(),
                 bgColor: bestMood.getMoodBackgroundColor())
            ChipView(chip: moodChip)
            if let confidence = bestMood.confidence
            {
                Text(StringUtilities.convertToPercentual(float: confidence))
            }
        }
    }
    
    var moodPhoto: some View
    {
        VStack
        {
            if let data = bestMood.statusInfo?.image
            {
                if let image = UIImage(data: data)
                {
                    RoundedRectagleImage(image: image).padding(.leading)
                }
            }
        }
    }
    
    var moodFooter: some View
    {
        VStack
        {
            if let date = bestMood.statusInfo?.date
            {
                Text(date.formatted(date: .long, time: .omitted))
                Text(date.formatted(date: .omitted, time: .standard))
            }
        }
    }
}

/*
 #Preview {
 DogDetailCard()
 }
 */
