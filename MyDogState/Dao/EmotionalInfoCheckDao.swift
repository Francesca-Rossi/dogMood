//
//  StatusInfoDao.swift
//  MyDogState
//
//  Created by Francesca Rossi on 21/12/23.
//

import Foundation
import CoreData

public class EmotionalInfoCheckDao: Dao
{
    
    typealias T = EmotionalInfoCheck
    private let persistent = PersistenceController.shared
    private let dogDao: DogDao?
    
    public init()
    {
        dogDao = DogDao()
    }
    
    private func getEntityById(_ id: UUID, errorInfo: inout ErrorInfo)  throws  -> EmotionalCheckInfoEntity?
    {
        do
        {
            let request = EmotionalCheckInfoEntity.fetchRequest()
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
    
    func fromObjectToEntity(obj: EmotionalInfoCheck?) throws -> EmotionalCheckInfoEntity?
    {
        //ATTENZIONE: non ha senso creare l'oggetto a DB tutte le volte, in quanto uno statusInfo puo' avere piu' risultati. Quindi prima andrebbero creato lo statusInfo e poi inseriti gli stati.
        let result = try runBlocking
        {
            var info = ErrorInfo()
            if let statusinfoID = obj?.id
            {
                do
                {
                    return try getEntityById(statusinfoID, errorInfo: &info)
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
    
    func fromEntityToObject(entity: EmotionalCheckInfoEntity?) throws -> EmotionalInfoCheck?
    {
        let result = try runBlocking
        {
            var info = ErrorInfo()
            if let statusinfoID = entity?.id
            {
                do
                {
                    return try await getById(statusinfoID, info: &info)
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
    
    func getAll(info: inout ErrorInfo) async throws -> [EmotionalInfoCheck]
    {
        do
        {
            
            let request = EmotionalCheckInfoEntity.fetchRequest()
            return try persistent.viewContext.fetch(request).map({ infoEntity in
                
                let infoCheck = try fromEntityToObject(entity: infoEntity)
                return EmotionalInfoCheck(
                    id: infoEntity.id,
                    date: infoEntity.date,
                    note: infoEntity.note,
                    dog: try dogDao?.fromEntityToObject(entity: infoEntity.dog),
                    statusList:  nil //try stateDao?.getAllStatusByCheck(infoCheck) Questo verra' aggiunto in un secondo momento dal BO
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
    
    func getById(_ id: UUID, info: inout ErrorInfo) async throws -> EmotionalInfoCheck? 
    {
        do
        {
            let checkEntity = try getEntityById(id, errorInfo: &info)!
            Logger.shared.log(checkEntity.toString(), level: LogLevel.Debug , saveToFile: true)
            return EmotionalInfoCheck(id: checkEntity.id,
                                      date: checkEntity.date,
                                      note: checkEntity.note,
                                      dog: try dogDao?.fromEntityToObject(entity: checkEntity.dog), statusList: nil /*vengono aggiunti dopo dal BO*/)
        }
        catch
        {
            info.setErrorMessage(value:  "\(error.localizedDescription)")
            Logger.shared.log(info.getErrorMessage(), level: LogLevel.Error , saveToFile: true)
            throw info
        }
    }
    
    func create(obj: EmotionalInfoCheck, info: inout ErrorInfo) async throws 
    {
        do
        {
            if let dog = try dogDao?.fromObjectToEntity(obj: obj.dog)
            {
                //ATTENZIONE: non possiamo creare il check se non esiste il cane a DB
                let infoCheckEntity = EmotionalCheckInfoEntity(context: persistent.viewContext)
                infoCheckEntity.id = obj.id
                infoCheckEntity.date = obj.date
                infoCheckEntity.note = obj.note
                infoCheckEntity.dog = dog
                Logger.shared.log(infoCheckEntity.toString(), level: LogLevel.Debug , saveToFile: true)
                //TODO: Ricordarsi a BO di creare anche gli stati associati a questo check
                try persistent.saveContext()
            }
            else
            {
                //Genero un errore dicendo che manca lo status info a database
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
    
    func update(id: UUID, obj: EmotionalInfoCheck, info: inout ErrorInfo) async throws 
    {
        do
        {
            //TODO: questi controlli vano fatti qui o a BO? (Dubbio)
            if let dog = try dogDao?.fromObjectToEntity(obj: obj.dog)
            //controllo che esista l'emotional check associato
            {
                let stateEntity = try getEntityById(id, errorInfo: &info)!
                stateEntity.date = obj.date
                stateEntity.note = obj.note
                stateEntity.dog = dog
                Logger.shared.log(stateEntity.toString(), level: LogLevel.Debug , saveToFile: true)
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
