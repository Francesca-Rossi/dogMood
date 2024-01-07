//
//  CheckMoodViewModel.swift
//  MyDogState
//
//  Created by Francesca Rossi on 06/01/24.
//

import Foundation

class CheckMoodViewModel: ObservableObject {
    
    @Published var emotionalInfoCheckList: [MoodCheckInfo] = []
    {
        willSet{
            objectWillChange.send()
        }
    }
   // var dao = DogDao()
    var emotionalManager = EmotionalStateManagerBO()
    var errorInfo = ErrorInfo() //TODO: gestisci meglio, forse va passato dalla UI?
    
    init()
    {
        getAllCheckMood()
    }
    
    public func getAllCheckMood()
    {
        do
        {
            emotionalInfoCheckList = try self.emotionalManager.getAllEmotionalCheck()

        }
        catch
        {
            Logger.shared.log(error.localizedDescription, level: LogLevel.Error , saveToFile: true)
        }
    }

    public func addNewEmotionalCheck(note: String?,  dog: Dog?, predictionList: [PredictionResult]) async
    {
        do
        {
            var checkInfo = MoodCheckInfo(id: UUID(), date: Date(), dog: dog, statusList: nil)
            try await emotionalManager.createEmotionalCheck(check: checkInfo, errorInfo: &errorInfo)
            
            if errorInfo.isAllOK()
            {
                for result in predictionList
                {
                    var moodDetail = MoodDetail(id: UUID(), mood: MoodResult.fromString(value: result.identifier), confidence: result.confidence, statusInfo: checkInfo)
                    try await emotionalManager.createMoodDetail(mood: moodDetail, errorInfo: &errorInfo)
                }
            }
        }
        catch
        {
            
        }
    }
}
