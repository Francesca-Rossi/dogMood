//
//  DogDetailCard.swift
//  MyDogState
//
//  Created by Francesca Rossi on 08/01/24.
//

import SwiftUI

struct DogDetailCard: View {
    var check: MoodCheckInfo
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
            if let mood = check.getTheBestConfidenceMood()
            {
                ChipView(chip: mood.getMoodChip())
                if let confidence = mood.confidence
                {
                    Text(StringUtilities.convertToPercentual(float: confidence))
                }
            }
        }
    }
    
    var moodPhoto: some View
    {
        VStack
        {
            if let data = check.image
            {
                if let image = UIImage(data: data)
                {
                    RoundedRectagleImage(image: image)
                        .padding(.leading)
                }
            }
        }
    }
    
    var moodFooter: some View
    {
        VStack
        {
            if let date = check.date
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
