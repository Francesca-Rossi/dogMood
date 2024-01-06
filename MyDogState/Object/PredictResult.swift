//
//  PredictResult.swift
//  MyDogState
//
//  Created by Francesca Rossi on 06/01/24.
//

import Foundation

struct PredictionResult: Identifiable
{
    var id: UUID = UUID()
    var confidence: Float
    var identifier: String
    
    func confidenceToString() -> String
    {
        return String(describing: confidence)
    }
    
    func toString() -> String
    {
        return String(format: "(%.2f) %@\n", confidence, identifier)
    }
}
