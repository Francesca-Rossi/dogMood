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
    
    private var subscribers: [AnyCancellable] = []
    
    var dao = DogDao()
    var emotionalManager = EmotionalStateManagerBO()
    
    init()
    {
        Task
        {
            await getAllDogs()
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
    
   func getAllDogs() async
    {
        var errorInfo = ErrorInfo()
            do {
                dogs = try  dao.getAll(info: &errorInfo)
                for i in dogs.indices
                {
                    dogs[i].emotionalCheckList = try emotionalManager.getAllMoodCheckByDogComplete(dog:dogs[i], info: &errorInfo)
                }
                checkDogStatus = !dogs.isEmpty
            }
            catch
            {
                //TODO: scrivi sul file di log
                print(errorInfo.getErrorMessage())
            }
    }
    
    func addNewDog(microchip: String, name: String, dateOfBirth: Date, image: UIImage, sex: String, breed: String?, hairColor: String?) async -> ErrorInfo
    {
        //TODO: fai tutti i controlli
        var errorInfo = ErrorInfo()
        do
        {
            if let data =  try? ImageUtilities(image: image).convertImageToData(error: &errorInfo)
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
                
                try await dao.create(obj: dog, info: &errorInfo)
                await self.getAllDogs()
            }
        }
        catch
        {
            //TODO: scrivi sul file di log
            print(errorInfo.getErrorMessage())
        }
        return errorInfo
    }
    
    public func deleteDog(offset: IndexSet) async
    {
         //offset.map{dogsList[$0]}.forEach(viewContext.delete)
         //save()
        var errorInfo = ErrorInfo()
        do
        {
            for i in offset.makeIterator() {
                let dog = dogsList[i]
                if let id = dog.id
                {
                    try await emotionalManager.deleteCheckAndMoodsByDog(dog: dog, info: &errorInfo)
                    if errorInfo.isAllOK()
                    {
                        try await dao.delete(id, info: &errorInfo)
                    }
                }
            }
            await getAllDogs()
        }
        catch
        {
            //TODO: scrivi sul file di log
            print(errorInfo.getErrorMessage())
        }
        
    }
    
    

}
