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
        let result = try runBlocking {
            var errorInfo = ErrorInfo()
            do
            {
                if let infoCheck = check
                {
                    return try await moodDetailDao?.getAll(info: &errorInfo).filter({status in status.statusInfo?.id == infoCheck.id })
                }
            }
            catch
            {
                errorInfo.setErrorMessage(value:  "\(error.localizedDescription)")
                Logger.shared.log(errorInfo.getErrorMessage(), level: LogLevel.Error , saveToFile: true)
                throw errorInfo
            }
            return nil
        }
        return result
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
        let result = try runBlocking {
            //var checkList:[EmotionalInfoCheck]?
            var errorInfo = ErrorInfo()
            do
            {
                //ritorno tutti i check emozionali
                if var checkList = try await self.moodCheckDao?.getAll(info: &errorInfo)
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
        return result
    }
    
    // MARK: - Method to return all the emotional check from ONE DOG
    func getAllEmotionalCheckByDog(dog: Dog) throws -> [MoodCheckInfo]
    {
        //Dammi la storia di tutti i check di uno specifico cane, con anche gli stati e il cane
        let result = try runBlocking {
            //var checkList:[EmotionalInfoCheck]?
            var errorInfo = ErrorInfo()
            do
            {
                //ritorno tutti i check emozionali
                if var checkList = try await self.moodCheckDao?.getAll(info: &errorInfo)
                {
                    //filtro solo i check del cane in questione
                    checkList = checkList.filter{$0.dog?.id == dog.id}
                    
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
        return result
    }
    
    func getTheBestConfidenceMood(check: MoodCheckInfo) -> MoodDetail?
    {
        if let moodList = check.moodDetailList
        {
            return moodList.max {
                ($0.confidence) ?? 0 < ($1.confidence) ?? 0
            }
        }
        return  nil
    }
}
