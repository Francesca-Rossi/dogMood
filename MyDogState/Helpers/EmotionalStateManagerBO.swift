//
//  EmotionalStateManagerBO.swift
//  MyDogState
//
//  Created by Francesca Rossi on 22/12/23.
//

import Foundation

public class EmotionalStateManagerBO
{
    var moodCheckDao: MoodCheckDao?
    var moodDetailDao: MoodDetailDao?
    
    public init()
    {
        //Inizializzo solo qui i DAO
        moodCheckDao = MoodCheckDao()
        moodDetailDao = MoodDetailDao(owner: moodCheckDao)
    }

    // MARK: - Method to return all the status of ONE EMOTIONAL CHECK
    func getAllMoodByCheck(_ check: MoodCheckInfo?) throws -> [MoodDetail]?
    {
        /* Ritorna la lista degli (stati, percentuale) presenti in un controllo
         */
            var errorInfo = ErrorInfo()
            var updateMoodList = [MoodDetail]()
            do
            {
                if let infoCheck = check
                {
                    if let moodList = try  moodDetailDao?.getAllNotAsync(info: &errorInfo)
                    {
                        for mood in moodList
                        {
                            if mood.statusInfo?.id == infoCheck.id
                            {
                                updateMoodList.append(mood)
                            }
                        }
                    }
                }
            }
            catch
            {
                errorInfo.setErrorMessage(value:  "\(error.localizedDescription)")
                Logger.shared.log(errorInfo.getErrorMessage(), level: LogLevel.Error , saveToFile: true)
                throw errorInfo
            }
            return updateMoodList
    }
    
    func createEmotionalCheck(check: MoodCheckInfo, errorInfo: inout ErrorInfo) async throws
    {
        do
        {
            try await moodCheckDao?.create(obj: check, info: &errorInfo)
        }
        catch
        {
            errorInfo.setErrorMessage(value:  "\(error.localizedDescription)")
            Logger.shared.log(errorInfo.getErrorMessage(), level: LogLevel.Error , saveToFile: true)
            throw errorInfo
        }
        
    }
    
    func createMoodDetail(mood: MoodDetail, errorInfo: inout ErrorInfo) async throws
    {
        do
        {
            try await moodDetailDao?.create(obj: mood, info: &errorInfo)
        }
        catch
        {
            errorInfo.setErrorMessage(value:  "\(error.localizedDescription)")
            Logger.shared.log(errorInfo.getErrorMessage(), level: LogLevel.Error , saveToFile: true)
            throw errorInfo
        }
        
    }
    
    
    /*func getAllCheckByDog(_ dog: Dog?) throws -> [EmotionalInfoCheck]?
    {
        //Questo risultato contiene i check ma non gli stati associati al check
        let result = try runBlocking {
            var errorInfo = ErrorInfo()
            do
            {
                if let dog = dog
                {
                    return try await checkDao?.getAll(info: &errorInfo).filter({check in check.dog?.id == dog.id})
                }
            }
            catch
            {
                errorInfo.setErrorMessage(value: "[DATABASE ERROR] \(error.localizedDescription)")
                throw errorInfo
            }
            return nil
        }
        return result
    }*/
    
    // MARK: - Method to return all the emotional check in the DB
    func getAllEmotionalCheck() throws -> [MoodCheckInfo]
    {
        //Dammi la storia di tutti i check, con anche gli stati e il cane
            var errorInfo = ErrorInfo()
            do
            {
                //ritorno tutti i check emozionali
                if var checkList = try  self.moodCheckDao?.getAllNotAsync(info: &errorInfo)
                {
                    //per ogni check carico i suoi stati e li vado a settare
                    for i in checkList.indices
                    {
                        checkList[i].moodDetailList = try getAllMoodByCheck(checkList[i])
                    }
                    return checkList
                }
            }
            catch
            {
                errorInfo.setErrorMessage(value:  "\(error.localizedDescription)")
                Logger.shared.log(errorInfo.getErrorMessage(), level: LogLevel.Error , saveToFile: true)
                throw errorInfo
            }
            return [MoodCheckInfo]() //se non ci sono stati a database

    }
    
    func getAllMoodCheckByDogComplete(dog: Dog, info: inout ErrorInfo) throws -> [MoodCheckInfo]
    {
        var moodCheckList = [MoodCheckInfo]()
        do
        {
            moodCheckList = try getAllEmotionalCheckByDogPartial(dog: dog)
            //per ogni check carico i suoi stati e li vado a settare
            for i in moodCheckList.indices
            {
                moodCheckList[i].moodDetailList = try getAllMoodByCheck(moodCheckList[i])
            } //per ogni check carico i suoi stati e li vado a settare
        }
        catch
        {
            info.setErrorMessage(value:  "\(error.localizedDescription)")
            Logger.shared.log(info.getErrorMessage(), level: LogLevel.Error , saveToFile: true)
            throw info
        }
        return moodCheckList
    }
    // MARK: - Method to return all the emotional check from ONE DOG
    func getAllEmotionalCheckByDogPartial(dog: Dog) throws -> [MoodCheckInfo]
    {
        //Dammi la storia di tutti i check di uno specifico cane, con anche gli stati e il cane
            //var checkList:[EmotionalInfoCheck]?
            var errorInfo = ErrorInfo()
            do
            {
                //ritorno tutti i check emozionali
                if var checkList = try  self.moodCheckDao?.getAllNotAsync(info: &errorInfo)
                {
                    //filtro solo i check del cane in questione
                    checkList = checkList.filter{$0.dog?.id == dog.id}
                    
                    return checkList
                }
            }
            catch
            {
                errorInfo.setErrorMessage(value:  "\(error.localizedDescription)")
                Logger.shared.log(errorInfo.getErrorMessage(), level: LogLevel.Error , saveToFile: true)
                throw errorInfo
            }
            return [MoodCheckInfo]() //se non ci sono stati a database
    }
    
    /**
            Call this method when dog is deleting
     */
    func deleteCheckAndMoodsByDog(dog: Dog, info: inout ErrorInfo) async throws
    {
        do
        {
            var checkList = try getAllMoodCheckByDogComplete(dog: dog, info: &info)
            for check in checkList
            {
                try await deleteCheckInfo(check: check, info: &info)
            }
        }
        catch
        {
            info.setErrorMessage(value:  "\(error.localizedDescription)")
            Logger.shared.log(info.getErrorMessage(), level: LogLevel.Error , saveToFile: true)
            throw info
        }
    }
    
    func deleteCheckInfo(check: MoodCheckInfo, info: inout ErrorInfo) async throws
    {
        do
        {
            //delete associated mood
            if let moodAssociatedList = check.moodDetailList
            {
                for mood in moodAssociatedList
                {
                    if let moodID = mood.id
                    {
                        try await moodDetailDao?.delete(moodID, info: &info)
                        
                    }
                }
            }
            if let checkID = check.id
            {
                try await moodCheckDao?.delete(checkID, info: &info)
            }
        }
        catch
        {
            info.setErrorMessage(value:  "\(error.localizedDescription)")
            Logger.shared.log(info.getErrorMessage(), level: LogLevel.Error , saveToFile: true)
            throw info
        }
    }
    
    
}
