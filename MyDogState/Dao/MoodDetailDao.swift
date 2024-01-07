//
//  StatusResultDao.swift
//  MyDogState
//
//  Created by Francesca Rossi on 21/12/23.
//

import Foundation
import CoreData
import os.lock

public class MoodDetailDao: Dao
{
    typealias T = MoodDetail
    private let persistent = PersistenceController.shared
    private var infoDao: MoodCheckDao?
    //static var lock = OSAllocatedUnfairLock ()
    
    public init(owner: MoodCheckDao?)
    {
        infoDao = owner 
    }
    
    private func getEntityById(_ id: UUID, errorInfo: inout ErrorInfo)  throws  -> MoodDetailEntity?
    {
        do
        {
            let request = MoodDetailEntity.fetchRequest()
            request.fetchLimit = 1
            request.predicate = NSPredicate(
                format: "id = %@", id.uuidString)
            let resultEntity = try persistent.viewContext.fetch(request)[0]
            Logger.shared.log(resultEntity.toString(), level: LogLevel.Debug , saveToFile: true)
            return resultEntity
        }
        catch
        {
            errorInfo.setErrorMessage(value:  "\(error.localizedDescription)")
            Logger.shared.log(errorInfo.getErrorMessage(), level: LogLevel.Error , saveToFile: true)
            throw errorInfo
        }
    }
    
    
    
    // MARK: - DAO methods
    func getAll(info: inout ErrorInfo) async throws -> [MoodDetail]
    {
        do
        {
            let request = MoodDetailEntity.fetchRequest()
            return try persistent.viewContext.fetch(request).map({ resultEntity in
                
                MoodDetail(id: resultEntity.id , mood: MoodResult.fromString(value: resultEntity.mood), confidence: resultEntity.confidence, statusInfo: try infoDao?.fromEntityToObject(entity: resultEntity.status_info))
            })
        }
        catch
        {
            info.setErrorMessage(value:  "\(error.localizedDescription)")
            Logger.shared.log(info.getErrorMessage(), level: LogLevel.Error , saveToFile: true)
            throw info
        }
    }

    func getById(_ id: UUID, info: inout ErrorInfo) async throws -> MoodDetail? 
    {
        do
        {
            if let resultEntity = try getEntityById(id, errorInfo: &info)
            {
                return MoodDetail(
                    id: resultEntity.id,
                    mood: MoodResult.fromString(value: resultEntity.mood),
                    confidence: resultEntity.confidence,
                    statusInfo: try infoDao?.fromEntityToObject(entity: resultEntity.status_info))
                Logger.shared.log(resultEntity.toString(), level: LogLevel.Debug , saveToFile: true)
            }
            return nil
        }
        catch
        {
            info.setErrorMessage(value:  "\(error.localizedDescription)")
            Logger.shared.log(info.getErrorMessage(), level: LogLevel.Error , saveToFile: true)
            throw info
        }
    }
    
    func create(obj: MoodDetail, info: inout ErrorInfo) async throws 
    {
        do
        {
            if let statusInfo = try infoDao?.fromObjectToEntity(obj: obj.statusInfo)
            {
                //ATTENZIONE: non possiamo creare i risultati del check se non abbiamo salvato prima l'emotional info check in database
                let statusResultEntity = MoodDetailEntity(context: persistent.viewContext)
                statusResultEntity.id = obj.id
                statusResultEntity.mood = MoodResult.toString(mood: obj.mood)
                statusResultEntity.confidence = obj.confidence ?? 0.0
                statusResultEntity.status_info = statusInfo
                Logger.shared.log(statusResultEntity.toString(), level: LogLevel.Debug , saveToFile: true)
                try persistent.saveContext()
            }
            else
            {
                //Genero un errore dicendo che manca lo status info a database
                info.setErrorMessage(value:  "Error - try to add new state without check info")
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
    
    func update(id: UUID, obj: MoodDetail, info: inout ErrorInfo) async throws 
    {
        do
        {
            //TODO: questi controlli vano fatti qui o a BO? (Dubbio)
            if let statusInfo = try infoDao?.fromObjectToEntity(obj: obj.statusInfo), let confidence =  obj.confidence
            //controllo che esista l'emotional check associato
            {
                let stateEntity = try getEntityById(id, errorInfo: &info)!
                stateEntity.confidence = confidence
                stateEntity.mood = MoodResult.toString(mood: obj.mood)
                stateEntity.status_info = statusInfo
                Logger.shared.log(stateEntity.toString(), level: LogLevel.Debug , saveToFile: true)
                try persistent.saveContext()
            }
            else
            {
                //Genero un errore dicendo che manca lo l'emotional info check a database
                info.setErrorMessage(value:  "Error - try to update the state without check info")
                Logger.shared.log(info.getErrorMessage(), level: LogLevel.Error , saveToFile: true)
                throw info
            }
        }
        catch
        {
            info.setErrorMessage(value: "\(error.localizedDescription)")
            Logger.shared.log(info.getErrorMessage(), level: LogLevel.Error , saveToFile: true)
            throw info
        }
    }
    
    func delete(_ id: UUID, info: inout ErrorInfo) async throws 
    {
        do
        {
            let MoodDetailEntity = try  getEntityById(id, errorInfo: &info)!
            persistent.viewContext.delete(MoodDetailEntity)
            Logger.shared.log(MoodDetailEntity.toString(), level: LogLevel.Debug , saveToFile: true)
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

