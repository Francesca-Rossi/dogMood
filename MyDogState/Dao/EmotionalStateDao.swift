//
//  StatusResultDao.swift
//  MyDogState
//
//  Created by Francesca Rossi on 21/12/23.
//

import Foundation
import CoreData
import os.lock

public class EmotionalStateDao: Dao
{
    typealias T = EmotionalState
    private let persistent = PersistenceController.shared
    private var infoDao: EmotionalInfoCheckDao?
    //static var lock = OSAllocatedUnfairLock ()
    
    public init(owner: EmotionalInfoCheckDao?)
    {
        infoDao = owner 
    }
    
    private func getEntityById(_ id: UUID, errorInfo: inout ErrorInfo)  throws  -> EmotionalStateEntity?
    {
        do
        {
            let request = EmotionalStateEntity.fetchRequest()
            request.fetchLimit = 1
            request.predicate = NSPredicate(
                format: "id = %@", id.uuidString)
            let resultEntity = try persistent.viewContext.fetch(request)[0]
            return resultEntity
        }
        catch
        {
            errorInfo.setErrorMessage(value: "DOG GET ALL ERROR: \(error.localizedDescription)")
            throw errorInfo
        }
    }
    
    
    
    // MARK: - DAO methods
    func getAll(info: inout ErrorInfo) async throws -> [EmotionalState]
    {
        do
        {
            let request = EmotionalStateEntity.fetchRequest()
            return try persistent.viewContext.fetch(request).map({ resultEntity in
                
                EmotionalState(id: resultEntity.id , state: resultEntity.status, percentual: resultEntity.percentual, statusInfo: try infoDao?.fromEntityToObject(entity: resultEntity.status_info))
            })
        }
        catch
        {
            info.setErrorMessage(value: "DOG GET ALL ERROR: \(error.localizedDescription)")
            throw info
        }
    }

    func getById(_ id: UUID, info: inout ErrorInfo) async throws -> EmotionalState? 
    {
        do
        {
            if let resultEntity = try getEntityById(id, errorInfo: &info)
            {
                return EmotionalState(
                    id: resultEntity.id,
                    state: resultEntity.status,
                    percentual: resultEntity.percentual,
                    statusInfo: try infoDao?.fromEntityToObject(entity: resultEntity.status_info))
            }
            return nil
        }
        catch
        {
            info.setErrorMessage(value: "DOG GET BY ID ERROR:\(error.localizedDescription)")
            throw info
        }
    }
    
    func create(obj: EmotionalState, info: inout ErrorInfo) async throws 
    {
        do
        {
            if let statusInfo = try infoDao?.fromObjectToEntity(obj: obj.statusInfo)
            {
                //ATTENZIONE: non possiamo creare i risultati del check se non abbiamo salvato prima l'emotional info check in database
                let statusResultEntity = EmotionalStateEntity(context: persistent.viewContext)
                statusResultEntity.id = obj.id
                statusResultEntity.status = obj.state
                statusResultEntity.percentual = obj.percentual ?? Double()
                statusResultEntity.status_info = statusInfo
                try persistent.saveContext()
            }
            else
            {
                //Genero un errore dicendo che manca lo status info a database
                info.setErrorMessage(value: "[DATABASE ERROR] hai provato ad aggiungere degli stati senza aver salvato le informazioni di quando questo check è avvenuto")
                throw info
            }
        }
        catch
        {
            info.setErrorMessage(value: "[DATABASE ERROR] \(error.localizedDescription)")
            throw info
        }
    }
    
    func update(id: UUID, obj: EmotionalState, info: inout ErrorInfo) async throws 
    {
        do
        {
            //TODO: questi controlli vano fatti qui o a BO? (Dubbio)
            if let statusInfo = try infoDao?.fromObjectToEntity(obj: obj.statusInfo), let percentual =  obj.percentual
            //controllo che esista l'emotional check associato
            {
                let stateEntity = try getEntityById(id, errorInfo: &info)!
                stateEntity.percentual = percentual
                stateEntity.status = obj.state
                stateEntity.status_info = statusInfo
                try persistent.saveContext()
            }
            else
            {
                //Genero un errore dicendo che manca lo l'emotional info check a database
                info.setErrorMessage(value: "[DATABASE ERROR] hai provato a aggiornare degli stati senza aver salvato le informazioni di quando questo check è avvenuto")
                throw info
            }
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
            let emotionalStateEntity = try  getEntityById(id, errorInfo: &info)!
            persistent.viewContext.delete(emotionalStateEntity)
            try persistent.saveContext()
        }
        catch{
            persistent.viewContext.rollback()
            info.setErrorMessage(value: "DOG DELETE ERROR: \(error.localizedDescription)")
            throw info
        }
    }
}

