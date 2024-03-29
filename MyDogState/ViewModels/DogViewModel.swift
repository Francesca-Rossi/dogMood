//
//  DogViewModel.swift
//  MyDogState
//
//  Created by Francesca Rossi on 10/07/23.
//

import Foundation
import SwiftUI
import Combine
import CoreData

@MainActor
class DogViewModel: ObservableObject {
    
    @Published var dogsList: [Dog] = []
    
    @Published var checkDogStatus: Bool = false
    
    
    @Published private var dogs: [Dog] = [Dog]()
    
    var dogsResultList: Published<[Dog]>.Publisher { $dogs }
    
    var isDogListEmpty: Bool
    {
        if dogsList.isEmpty
        {
            return true
        }
        return false
    }
    
    private var subscribers: [AnyCancellable] = []
    
    var dao = DogDao()
    var emotionalManager = EmotionalStateManagerBO()
    
    init()
    {
        var info = ErrorInfo()
        Task
        {
            await getAllDogs(info: &info)
        }
        self.subscribe()
    }
    
    func subscribe() {
        self.dogsResultList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newDogs in
                self?.dogsList = newDogs
            }
            .store(in: &subscribers)
    }
    
    func getAllDogs(info: inout ErrorInfo) async
    {
            do {
                dogs = try  dao.getAll(info: &info)
                for i in dogs.indices
                {
                    dogs[i].emotionalCheckList = try emotionalManager.getAllMoodCheckByDogComplete(dog:dogs[i], info: &info)
                }
                checkDogStatus = !dogs.isEmpty
            }
            catch
            {
                Logger.shared.log(info.getErrorMessage(), level: LogLevel.Error , saveToFile: true)
                print(info.getErrorMessage())
            }
    }
    
    func addNewDog(microchip: String, name: String, dateOfBirth: Date, image: UIImage, sex: String, breed: String?, hairColor: String?, info: inout ErrorInfo) async
    {
        do
        {
            if let data =  try? ImageUtilities(image: image).convertImageToData(error: &info)
            {
                let dog =  Dog(id: UUID(),
                               name: name,
                               microchip: microchip,
                               dateOfBirth: dateOfBirth,
                               image: data,
                               breed: breed,
                               sex: sex,
                               hairColor: hairColor,
                               date: Date(), emotionalCheckList: nil) //all'inizio il cane non ha stati.
                
                try await dao.create(obj: dog, info: &info)
                await self.getAllDogs(info: &info)
            }
        }
        catch
        {
            Logger.shared.log(info.getErrorMessage(), level: LogLevel.Error , saveToFile: true)
            print(info.getErrorMessage())
        }
    }
    
    public func deleteDog(offset: IndexSet, info: inout ErrorInfo) async
    {
        do
        {
            for i in offset.makeIterator() {
                let dog = dogsList[i]
                if let id = dog.id
                {
                    try await emotionalManager.deleteCheckAndMoodsByDog(dog: dog, info: &info)
                    if info.isAllOK()
                    {
                        try await dao.delete(id, info: &info)
                    }
                }
            }
            await getAllDogs(info: &info)
        }
        catch
        {
            Logger.shared.log(info.getErrorMessage(), level: LogLevel.Error , saveToFile: true)
            print(info.getErrorMessage())
        }
        
    }
    
    

}
