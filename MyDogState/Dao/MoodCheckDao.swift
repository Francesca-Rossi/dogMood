//
//  StatusInfoDao.swift
//  MyDogState
//
//  Created by Francesca Rossi on 21/12/23.
//

import Foundation
import CoreData

public class MoodCheckDao: Dao
{
    
    typealias T = MoodCheckInfo
    private let persistent = PersistenceController.shared
    private let dogDao: DogDao?
    
    public init()
    {
        dogDao = DogDao()
    }
    
    private func getEntityById(_ id: UUID, errorInfo: inout ErrorInfo)  throws  -> MoodCheckEntity?
    {
        do
        {
            let request = MoodCheckEntity.fetchRequest()
            request.fetchLimit = 1
            request.predicate = NSPredicate(
                format: "id = %@", id.uuidString)
            let infoEntity = try persistent.viewContext.fetch(request)[0]
            Logger.shared.log(infoEntity.toString(), level: LogLevel.Debug , saveToFile: true)
            return infoEntity
        }
        catch
        {
            errorInfo.setErrorMessage(value:  "\(error.localizedDescription)")
            Logger.shared.log(errorInfo.getErrorMessage(), level: LogLevel.Error , saveToFile: true)
            throw errorInfo
        }
    }
    
    func fromObjectToEntity(obj: MoodCheckInfo?) throws -> MoodCheckEntity?
    {
        //ATTENZIONE: non ha senso creare l'oggetto a DB tutte le volte, in quanto uno statusInfo puo' avere piu' risultati. Quindi prima andrebbero creato lo statusInfo e poi inseriti gli stati.
        let result = try runBlocking
        {
            var info = ErrorInfo()
            if let moodCheckID = obj?.id
            {
                do
                {
                    return try getEntityById(moodCheckID, errorInfo: &info)
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
        Logger.shared.log(result?.toString(), level: LogLevel.Debug , saveToFile: true)
        return result
    }
    
    func fromEntityToObject(entity: MoodCheckEntity?) throws -> MoodCheckInfo?
    {
        let result = try runBlocking
        {
            var info = ErrorInfo()
            if let mooodCheckID = entity?.id
            {
                do
                {
                    return try await getById(mooodCheckID, info: &info)
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
        Logger.shared.log(result?.toString(), level: LogLevel.Debug , saveToFile: true)
       return result
    }
    
    // MARK: - DAO methods
    
    func getAll(info: inout ErrorInfo) async throws -> [MoodCheckInfo]
    {
        do
        {
            
            let request = MoodCheckEntity.fetchRequest()
            return try persistent.viewContext.fetch(request).map({ infoEntity in
                
                return MoodCheckInfo(
                    id: infoEntity.id,
                    date: infoEntity.date,
                    note: infoEntity.note,
                    dog: try dogDao?.fromEntityToObject(entity: infoEntity.dog),
                    moodDetailList:  nil,
                    image: infoEntity.image
                )
            })
        }
        catch
        {
            info.setErrorMessage(value:  "\(error.localizedDescription)")
            Logger.shared.log(info.getErrorMessage(), level: LogLevel.Error , saveToFile: true)
            throw info
        }
    }
    
    func getById(_ id: UUID, info: inout ErrorInfo) async throws -> MoodCheckInfo? 
    {
        do
        {
            let checkEntity = try getEntityById(id, errorInfo: &info)!
            Logger.shared.log(checkEntity.toString(), level: LogLevel.Debug , saveToFile: true)
            return MoodCheckInfo(id: checkEntity.id,
                                 date: checkEntity.date,
                                 note: checkEntity.note,
                                 dog: try dogDao?.fromEntityToObject(entity: checkEntity.dog),
                                 moodDetailList: nil,
                                 image: checkEntity.image)
        }
        catch
        {
            info.setErrorMessage(value:  "\(error.localizedDescription)")
            Logger.shared.log(info.getErrorMessage(), level: LogLevel.Error , saveToFile: true)
            throw info
        }
    }
    
    func create(obj: MoodCheckInfo, info: inout ErrorInfo) async throws 
    {
        do
        {
            if let dog = try dogDao?.fromObjectToEntity(obj: obj.dog)
            {
                //ATTENZIONE: non possiamo creare il check se non esiste il cane a DB
                let infoCheckEntity = MoodCheckEntity(context: persistent.viewContext)
                infoCheckEntity.id = obj.id
                infoCheckEntity.date = obj.date
                infoCheckEntity.note = obj.note
                infoCheckEntity.dog = dog
                infoCheckEntity.image = obj.image
                Logger.shared.log(infoCheckEntity.toString(), level: LogLevel.Debug , saveToFile: true)
                //TODO: Ricordarsi a BO di creare anche i dettagli del mood associati a questo check
                try persistent.saveContext()
            }
            else
            {
                info.setErrorMessage(value:  "Error - try to add new check without dog info")
                Logger.shared.log(info.getErrorMessage(), level: LogLevel.Error , saveToFile: true)
                throw info
            }
        }
        catch
        {
            info.setErrorMessage(value:  "\(error.localizedDescription)")
            Logger.shared.log(info.getErrorMessage(), level: LogLevel.Error , saveToFile: true)
            throw info
        }
    }
    
    func update(id: UUID, obj: MoodCheckInfo, info: inout ErrorInfo) async throws 
    {
        do
        {
            //TODO: questi controlli vano fatti qui o a BO? (Dubbio)
            if let dog = try dogDao?.fromObjectToEntity(obj: obj.dog)
            //controllo che esista l'emotional check associato
            {
                let checkEntity = try getEntityById(id, errorInfo: &info)!
                checkEntity.date = obj.date
                checkEntity.note = obj.note
                checkEntity.dog = dog
                checkEntity.image = obj.image
                Logger.shared.log(checkEntity.toString(), level: LogLevel.Debug , saveToFile: true)
                try persistent.saveContext()
            }
            else
            {
                info.setErrorMessage(value:  "Error - try to update check without dog info")
                Logger.shared.log(info.getErrorMessage(), level: LogLevel.Error , saveToFile: true)
                throw info
            }
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
        //ATTENZIONE: quando cancelli uno check emozionale devi controllare che anche tutti i suoi stati sono stati cancellati
        do
        {
            //TODO: nel bo dobbiamo prima cancellare i suoi stati
            let checkEntity = try  getEntityById(id, errorInfo: &info)!
            Logger.shared.log(checkEntity.toString(), level: LogLevel.Debug , saveToFile: true)
            persistent.viewContext.delete(checkEntity)
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
