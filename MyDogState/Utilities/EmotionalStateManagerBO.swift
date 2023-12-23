//
//  EmotionalStateManagerBO.swift
//  MyDogState
//
//  Created by Francesca Rossi on 22/12/23.
//

import Foundation

public class EmotionalStateManagerBO
{
    var checkDao: EmotionalInfoCheckDao?
    var stateDao: EmotionalStateDao?
    
    public init()
    {
        //Inizializzo solo qui i DAO
        checkDao = EmotionalInfoCheckDao()
        stateDao = EmotionalStateDao(owner: checkDao)
    }

    // MARK: - Method to return all the status of ONE EMOTIONAL CHECK
    func getAllStatusByCheck(_ check: EmotionalInfoCheck?) throws -> [EmotionalState]?
    {
        /* Ritorna la lista degli (stati, percentuale) presenti in un controllo
         */
        let result = try runBlocking {
            var errorInfo = ErrorInfo()
            do
            {
                if let infoCheck = check
                {
                    return try await stateDao?.getAll(info: &errorInfo).filter({status in status.statusInfo?.id == infoCheck.id })
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
    func getAllEmotionalCheck() throws -> [EmotionalInfoCheck]
    {
        //Dammi la storia di tutti i check, con anche gli stati e il cane
        let result = try runBlocking {
            //var checkList:[EmotionalInfoCheck]?
            var error = ErrorInfo()
            do
            {
                //ritorno tutti i check emozionali
                if var checkList = try await self.checkDao?.getAll(info: &error)
                {
                    //per ogni check carico i suoi stati e li vado a settare
                    for i in checkList.indices
                    {
                        checkList[i].statusList = try getAllStatusByCheck(checkList[i])
                    }
                    return checkList
                }
            }
            catch
            {
                //TODO: scrivi sul file di log
                print(error.localizedDescription)
            }
            return [EmotionalInfoCheck]() //se non ci sono stati a database
        }
        return result
    }
    
    // MARK: - Method to return all the emotional check from ONE DOG
    func getAllEmotionalCheckByDog(dog: Dog) throws -> [EmotionalInfoCheck]
    {
        //Dammi la storia di tutti i check di uno specifico cane, con anche gli stati e il cane
        let result = try runBlocking {
            //var checkList:[EmotionalInfoCheck]?
            var error = ErrorInfo()
            do
            {
                //ritorno tutti i check emozionali
                if var checkList = try await self.checkDao?.getAll(info: &error)
                {
                    //filtro solo i check del cane in questione
                    checkList = checkList.filter{$0.dog?.id == dog.id}
                    
                    //per ogni check carico i suoi stati e li vado a settare
                    for i in checkList.indices
                    {
                        checkList[i].statusList = try getAllStatusByCheck(checkList[i])
                    }
                    return checkList
                }
            }
            catch
            {
                //TODO: scrivi sul file di log
                print(error.localizedDescription)
            }
            return [EmotionalInfoCheck]() //se non ci sono stati a database
        }
        return result
    }
}
