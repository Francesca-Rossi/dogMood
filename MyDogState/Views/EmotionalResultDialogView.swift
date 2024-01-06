//
//  EmotionalResultDialogView.swift
//  MyDogState
//
//  Created by Francesca Rossi on 06/01/24.
//

import SwiftUI

struct EmotionalResultDialogView: View {
    
    let MOOD_RESULT_LABEL = "Dog mood"
    let MAX_FONT_SIZE = 40
    
    var predictionResult: [PredictionResult] //TODO: al posto di questo ci sarà un viewModel
    var body: some View {
    
            List(predictionResult)
            { result in
                HStack
                {
                    ChipView(chip: createChip(prediction: result))
                    Text(StringUtilities.convertToPercentual(float: result.confidence))
                        .font(.system(size: CGFloat(result.confidence * 100), weight: .semibold))
                    //MAX_FONT_SIZE-(index * 10)
                }
            }.frame(minHeight: CGFloat(300.0))
        
        
    }
    
    //TODO: remove this and create a factory in chip class
    func createChip(prediction: PredictionResult) -> Chip
    {
        //TODO: remove this, lo dara' la BL
        let info = MoodDetail(id: UUID(),
                                 mood: MoodResult.fromString(value: prediction.identifier),
                              confidence: Double(prediction.confidence),
                                 statusInfo: nil) //TODO: passare lo statusInfo
        return Chip(title:  MoodResult.toString(mood: info.mood),                       titleColor: info.getMoodForegroundColor(),
                    bgColor: info.getMoodBackgroundColor())
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
