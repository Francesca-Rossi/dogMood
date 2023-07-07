//
//  DataController.swift
//  MyDogState
//
//  Created by Francesca Rossi on 04/07/23.
//

import Foundation
import CoreData

class DataController: ObservableObject
{
    let container = NSPersistentContainer(name: "DogModel") //name del modello
    
    init()
    {
        container.loadPersistentStores{ desc, error in
            if let error = error
            {
                print("failed to load the data \(error.localizedDescription)")
            }
        }
    }
    
    func save(context: NSManagedObjectContext)
    {
        do
        {
            try context.save()
            print("data saved")
        }
        catch
        {
            print("we couldn't saved")
        }
    }
    
    func addDog(microchip: String, name: String, dateOfBirth: Date, image: Data?, sex: String, breed: String?, hairColor: String?, context: NSManagedObjectContext)
    {
        let dog = Dog(context: context)
        dog.id = UUID()
        dog.microchip = microchip //TODO: controlla che non sia gia' presente un microchip uguale nel database
        dog.name = name
        dog.image = image
        dog.dateOfBirth = dateOfBirth
        dog.sex = sex
        dog.breed = breed
        dog.hairColor = hairColor
        dog.date = Date() //first insert date
        save(context: context)
    }
    
    func editDog(dog: Dog, name: String, dateOfBirth: Date, image: Data?, sex: String, breed: String?, hairColor: String?, context: NSManagedObjectContext)
    {
        let dog = Dog(context: context)
        dog.name = name
        dog.image = image
        dog.dateOfBirth = dateOfBirth
        dog.sex = sex
        dog.breed = breed
        dog.hairColor = hairColor
        
        save(context: context)
    }
    
    
}


