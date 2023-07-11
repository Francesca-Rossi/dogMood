//
//  DogDao.swift
//  MyDogState
//
//  Created by Francesca Rossi on 11/07/23.
//

import Foundation
import CoreData

public class DogDao: Dao
{
    typealias T = Dog
    private let persistent = PersistenceController.shared
    
    func getAll(info: inout ErrorInfo) throws -> [Dog]
    {
        do
        {
            let request = DogEntity.fetchRequest()
            return try persistent.viewContext.fetch(request).map({ dogEntity in
                Dog(id: dogEntity.id,
                    name: dogEntity.name,
                    microchip: dogEntity.microchip,
                    dateOfBirth: dogEntity.dateOfBirth,
                    image: dogEntity.image,
                    breed: dogEntity.breed,
                    sex: dogEntity.sex,
                    hairColor: dogEntity.hairColor,
                    date: dogEntity.date)
            })
        }
        catch
        {
            info.setErrorMessage(value: "DOG GET ALL ERROR: \(error.localizedDescription)")
            throw info
        }
    }
    
    func getById(_ id: UUID, info: inout ErrorInfo)  throws -> Dog?
    {
        do
        {
            let dogEntity = try getEntityById(id)!
            return Dog(id: dogEntity.id,
             name: dogEntity.name,
             microchip: dogEntity.microchip,
             dateOfBirth: dogEntity.dateOfBirth,
             image: dogEntity.image,
             breed: dogEntity.breed,
             sex: dogEntity.sex,
             hairColor: dogEntity.hairColor,
             date: dogEntity.date)
        }
        catch
        {
            info.setErrorMessage(value: "DOG GET BY ID ERROR:\(error.localizedDescription)")
            throw info
        }
    }
    
    func create(obj: Dog, info: inout ErrorInfo) async throws 
    {
        do
        {
            let dogEntity = DogEntity(context: persistent.viewContext)
            dogEntity.id = obj.id
            dogEntity.name = obj.name
            dogEntity.microchip = obj.microchip
            dogEntity.image = obj.image
            dogEntity.dateOfBirth = obj.date
            dogEntity.date = obj.date
            dogEntity.sex = obj.sex
            dogEntity.hairColor = obj.hairColor
            dogEntity.breed = obj.breed
            try persistent.saveContext()
        }
        catch
        {
            info.setErrorMessage(value: "DOG CREATE ERROR: \(error.localizedDescription)")
            throw info
        }
    }
    
    func update(id: UUID, obj: Dog, info: inout ErrorInfo) async throws
    {
        do
        {
            let dogEntity = try getEntityById(id)!
            dogEntity.id = obj.id
            dogEntity.name = obj.name
            dogEntity.microchip = obj.microchip
            dogEntity.image = obj.image
            dogEntity.dateOfBirth = obj.date
            dogEntity.date = obj.date
            dogEntity.sex = obj.sex
            dogEntity.hairColor = obj.hairColor
            dogEntity.breed = obj.breed
            try persistent.saveContext()
        }
        catch
        {
            info.setErrorMessage(value: "DOG UPDATE ERROR: \(error.localizedDescription)")
            throw info
        }
    }
    
    func delete(_ id: UUID, info: inout ErrorInfo) async throws
    {
        do
        {
            let dogEntity = try  getEntityById(id)!
            persistent.viewContext.delete(dogEntity)
            try persistent.saveContext()
        }
        catch{
            persistent.viewContext.rollback()
            info.setErrorMessage(value: "DOG DELETE ERROR: \(error.localizedDescription)")
            throw info
        }
    }
    
    private func getEntityById(_ id: UUID)  throws  -> DogEntity?
    {
        let request = DogEntity.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(
            format: "id = %@", id.uuidString)
        let dogEntity = try persistent.viewContext.fetch(request)[0]
        return dogEntity
    }
    
   
}
