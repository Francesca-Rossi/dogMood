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
    private let viewContext = PersistenceController.shared.viewContext
    @Published var dogsList: [Dog] = []
    {
        willSet{
            objectWillChange.send()
        }
    }
    
    init() {
        getAllDogs()
    }
    
    func getAllDogs()
    {
        //create NSFetchRequest
        //TODO c'e' il modo di filtrare velocemente con le NSFetchRequest, cerca online
        let request = NSFetchRequest<Dog>(entityName: "Dog")
        
        do {
            dogsList = try viewContext.fetch(request)
        }catch {
            print("DEBUG: Some error occured while fetching")
        }
    }
    
    
    
    func addNewDog(microchip: String, name: String, dateOfBirth: Date, image: Data?, sex: String, breed: String?, hairColor: String?)
    {
        let dog = Dog(context: viewContext)
        dog.id = UUID()
        dog.microchip = microchip //TODO: controlla che non sia gia' presente un microchip uguale nel database
        dog.name = name
        dog.image = image
        dog.dateOfBirth = dateOfBirth
        dog.sex = sex
        dog.breed = breed
        dog.hairColor = hairColor
        dog.date = Date() //first insert date
        
        save()
        self.getAllDogs()
    }
    
    public func deleteDog(offset: IndexSet)
    {
         offset.map{dogsList[$0]}.forEach(viewContext.delete)
         save()
    }
    
    func save() {
        do {
            try viewContext.save()
        }catch {
            print("Error saving")
        }
    }
}
