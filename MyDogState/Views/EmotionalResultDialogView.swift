//
//  EmotionalResultDialogView.swift
//  MyDogState
//
//  Created by Francesca Rossi on 06/01/24.
//

import SwiftUI

struct EmotionalResultDialogView: View {
    
    let MOOD_RESULT_LABEL = "Dog mood"
    
    var predictionResult: [PredictionResult]
    
    var body: some View {
        VStack(alignment: .center, spacing: 5)
        {
            Text("Mood results")
                .font(.system(size: CGFloat(30.0), weight: .bold))
                .minimumScaleFactor(0.5)
            List(predictionResult)
            { result in
                HStack
                {
                    ChipView(chip: createChip(prediction: result))
                        .frame(width: 200)
                    Text(StringUtilities.convertToPercentual(float: result.confidence))
                        .font(confidenceToSize(confidence: result.confidence))
                        .frame(alignment: .trailing)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color(UIColor.systemGray6))
            }
            .frame(minHeight: CGFloat(200.0))
            .listStyle(PlainListStyle())
        }//.background(Color(UIColor.systemGray6))
    }
    
    func confidenceToSize(confidence: Float) -> Font
    {
        var percentual = confidence * 100
        if percentual >= 75
        {
            return Font.system(size: CGFloat(45.0), weight: .semibold)
        }
        else if percentual >= 60
        {
            return Font.system(size: CGFloat(40.0), weight: .semibold)
        }
        else if percentual >= 40
        {
            return Font.system(size: CGFloat(35.0), weight: .semibold)
        }
        else if percentual >= 20
        {
            return Font.system(size: CGFloat(30.0), weight: .light)
        }
        else
        {
            return Font.system(size: CGFloat(25.0), weight: .light)
        }
    }
    
    //TODO: remove this and create a factory in chip class
    func createChip(prediction: PredictionResult) -> Chip
    {
        //TODO: remove this, lo dara' la BL
        let info = MoodDetail(
                            id: UUID(),
                            mood: MoodResult.fromString(value: prediction.identifier),
                            confidence: prediction.confidence,
                            statusInfo: nil)
        return info.getMoodChip()
    }
}

struct EmotionalResultDialogView_Previews: PreviewProvider
{
    static var previews: some View {
        //let info = EmotionalInfo(id: UUID(), mood: MoodResult.fromString(value: "happy"), percentual: Double(3.4), statusInfo: nil)
        let prediction = PredictionResult(confidence: 3.4, identifier: "happy")
        EmotionalResultDialogView(predictionResult: [prediction])
}
    
}
