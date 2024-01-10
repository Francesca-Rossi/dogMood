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
    
    private func getEntityById(_ id: UUID)  throws  -> DogEntity?
    {
        let request = DogEntity.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(
            format: "id = %@", id.uuidString)
        let dogEntity = try persistent.viewContext.fetch(request)[0]
        Logger.shared.log(dogEntity.toString(), level: LogLevel.Debug , saveToFile: true)
        return dogEntity
    }
    
    func fromEntityToObject(entity: DogEntity?) throws -> Dog?
    {
            var info = ErrorInfo()
            if let dogId = entity?.id
            {
                do
                {
                    return try getById(dogId, info: &info)
                }
                catch
                {
                    info.setErrorMessage(value:  "\(error.localizedDescription)")
                    Logger.shared.log(info.getErrorMessage(), level: LogLevel.Error , saveToFile: true)
                    throw info
                }
            }
            return nil
    }
    func fromObjectToEntity(obj: Dog?) throws -> DogEntity?
    {
            var info = ErrorInfo()
            if let dogID = obj?.id
            {
                do
                {
                    return try getEntityById(dogID)
                }
                catch
                {
                    info.setErrorMessage(value:  "\(error.localizedDescription)")
                    Logger.shared.log(info.getErrorMessage(), level: LogLevel.Error , saveToFile: true)
                    throw info
                }
            }
            return nil

    }
    // MARK: - DAO methods
    
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
                    date: dogEntity.date, emotionalCheckList: nil)
            })
        }
        catch
        {
            info.setErrorMessage(value:  "\(error.localizedDescription)")
            Logger.shared.log(info.getErrorMessage(), level: LogLevel.Error , saveToFile: true)
            throw info
        }
    }
    
    func getById(_ id: UUID, info: inout ErrorInfo) throws -> Dog?
    {
        do
        {
            let dogEntity = try getEntityById(id)!
            Logger.shared.log(dogEntity.toString(), level: LogLevel.Debug , saveToFile: true)
            return Dog(id: dogEntity.id,
             name: dogEntity.name,
             microchip: dogEntity.microchip,
             dateOfBirth: dogEntity.dateOfBirth,
             image: dogEntity.image,
             breed: dogEntity.breed,
             sex: dogEntity.sex,
             hairColor: dogEntity.hairColor,
                       date: dogEntity.date, emotionalCheckList: nil)
        }
        catch
        {
            info.setErrorMessage(value:  "\(error.localizedDescription)")
            Logger.shared.log(info.getErrorMessage(), level: LogLevel.Error , saveToFile: true)
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
            dogEntity.dateOfBirth = obj.dateOfBirth
            dogEntity.date = obj.date //data di inserimento
            dogEntity.sex = obj.sex
            dogEntity.hairColor = obj.hairColor
            dogEntity.breed = obj.breed
            Logger.shared.log(dogEntity.toString(), level: LogLevel.Debug , saveToFile: true)
            try persistent.saveContext()
        }
        catch
        {
            info.setErrorMessage(value:  "\(error.localizedDescription)")
            Logger.shared.log(info.getErrorMessage(), level: LogLevel.Error , saveToFile: true)
            throw info
        }
    }
    
    func update(id: UUID, obj: Dog, info: inout ErrorInfo) async throws
    {
        do
        {
            let dogEntity = try getEntityById(id)!
            dogEntity.name = obj.name
            dogEntity.microchip = obj.microchip
            dogEntity.image = obj.image
            dogEntity.dateOfBirth = obj.date
            dogEntity.date = obj.date
            dogEntity.sex = obj.sex
            dogEntity.hairColor = obj.hairColor
            dogEntity.breed = obj.breed
            Logger.shared.log(dogEntity.toString(), level: LogLevel.Debug , saveToFile: true)
            try persistent.saveContext()
        }
        catch
        {
            info.setErrorMessage(value:  "\(error.localizedDescription)")
            Logger.shared.log(info.getErrorMessage(), level: LogLevel.Error , saveToFile: true)
            throw info
        }
    }
    
    func delete(_ id: UUID, info: inout ErrorInfo) async throws
    {
        do
        {
            let dogEntity = try  getEntityById(id)!
            Logger.shared.log(dogEntity.toString(), level: LogLevel.Debug , saveToFile: true)
            persistent.viewContext.delete(dogEntity)
            try persistent.saveContext()
        }
        catch{
            persistent.viewContext.rollback()
            info.setErrorMessage(value:  "\(error.localizedDescription)")
            Logger.shared.log(info.getErrorMessage(), level: LogLevel.Error , saveToFile: true)
            throw info
        }
    }
}
