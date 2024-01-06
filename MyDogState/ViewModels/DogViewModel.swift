//
//  DogViewModel.swift
//  MyDogState
//
//  Created by Francesca Rossi on 10/07/23.
//

import Foundation
import SwiftUI
import CoreData

class DogViewModel: ObservableObject {
    
    @Published var dogsList: [Dog] = []
    {
        willSet{
            objectWillChange.send()
        }
    }
    var dao = DogDao()
    var emotionalManager = EmotionalStateManagerBO()
    var errorInfo = ErrorInfo()
    
    init()
    {
        getAllDogs()
    }
    
   func getAllDogs()
    {
            do {
                dogsList = try  dao.getAll(info: &errorInfo)
                for i in dogsList.indices
                {
                    dogsList[i].emotionalCheckList = try emotionalManager.getAllEmotionalCheckByDog(dog:dogsList[i])
                }
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
                self.getAllDogs()
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
        do
        {
            for i in offset.makeIterator() {
                let dog = dogsList[i]
                if let id = dog.id
                {
                    try await dao.delete(id, info: &errorInfo)
                }
            }
            getAllDogs()
        }
        catch
        {
            //TODO: scrivi sul file di log
            print(errorInfo.getErrorMessage())
        }
        
    }
    
    public func addNewEmotionalCheck(date: Date?,  note: String?,  dog: Dog?, statusList: [MoodDetail]?)
    {
        
    }
}
