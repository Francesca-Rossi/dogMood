//
//  CheckMoodViewModel.swift
//  MyDogState
//
//  Created by Francesca Rossi on 06/01/24.
//
import Combine
import Foundation
import UIKit

@MainActor
class CheckMoodViewModel: ObservableObject {
    
    @Published var emotionalInfoCheckList: [MoodCheckInfo] = []
//    {
//        willSet{
//            objectWillChange.send()
//        }
//    }
    
    @Published private var checks: [MoodCheckInfo] = [MoodCheckInfo]()
    
    var checkResultList: Published<[MoodCheckInfo]>.Publisher { $checks }
    
    private var subscribers: [AnyCancellable] = []
    
    var emotionalManager = EmotionalStateManagerBO()
    
    
    init()
    {
        Task
        {
            await getAllCheckMood()
        }
        self.subscribe()
    }
    
    func subscribe() {
        self.checkResultList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newCheck in
                self?.emotionalInfoCheckList = newCheck
            }
            .store(in: &subscribers)
    }
    
    public func getAllCheckMood() async
    {
        do
        {
            checks = try self.emotionalManager.getAllEmotionalCheck().sorted(by: {
                if let date1 = $0.date, let date2 = $1.date
                {
                   return date1.compare(date2) == .orderedDescending
                }
                return false
            })

        }
        catch
        {
            Logger.shared.log(error.localizedDescription, level: LogLevel.Error , saveToFile: true)
        }
    }
    
    

    public func addNewEmotionalCheck(note: String,  dog: Dog, image: UIImage, predictionList: [PredictionResult]) async -> ErrorInfo
    {
        var errorInfo = ErrorInfo()
        do
        {
            if let data =  try? ImageUtilities(image: image).convertImageToData(error: &errorInfo)
            {
                let checkInfo = MoodCheckInfo(id: UUID(), date: Date(), note: note, dog: dog, moodDetailList: nil, image: data)
                try await emotionalManager.createEmotionalCheck(check: checkInfo, errorInfo: &errorInfo)
                
                if errorInfo.isAllOK()
                {
                    for result in predictionList
                    {
                        let moodDetail = MoodDetail(id: UUID(), mood: MoodResult.fromString(value: result.identifier), confidence: result.confidence, statusInfo: checkInfo)
                        try await emotionalManager.createMoodDetail(mood: moodDetail, errorInfo: &errorInfo)
                        await self.getAllCheckMood()
                    }
                }
            }
        }
        catch
        {
            errorInfo.setErrorMessage(value:  "\(error.localizedDescription)")
            Logger.shared.log(errorInfo.getErrorMessage(), level: LogLevel.Error , saveToFile: true)
        }
        return errorInfo
    }
    
    public func deleteCheck(offset: IndexSet) async
    {
        var errorInfo = ErrorInfo()
        do
        {
            for i in offset.makeIterator() 
            {
                let check = emotionalInfoCheckList[i]
                try await emotionalManager.deleteCheckInfo(check: check, info: &errorInfo)
            }
            if errorInfo.isAllOK()
            {
                await getAllCheckMood()
            }
        }
        catch
        {
            //TODO: scrivi sul file di log
            print(errorInfo.getErrorMessage())
        }
        
    }
}
