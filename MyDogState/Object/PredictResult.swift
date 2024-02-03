//
//  PredictResult.swift
//  MyDogState
//
//  Created by Francesca Rossi on 06/01/24.
//

import Foundation

//class used for the classification output
struct PredictionResult: Identifiable
{
    var id: UUID = UUID()
    var confidence: Float
    var identifier: String
    
    //TODO: check if used and remove this
    func confidenceToString() -> String
    {
        return String(describing: confidence)
    }
    
    //TODO: check if used and remove this
    func toString() -> String
    {
        return String(format: "(%.2f) %@\n", confidence, identifier)
    }
}
