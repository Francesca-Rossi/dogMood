//
//  DogEntity+CoreDataClass.swift
//  MyDogState
//
//  Created by Francesca Rossi on 07/01/24.
//
//

import Foundation
import CoreData

@objc(DogEntity)
public class DogEntity: NSManagedObject {

}

extension DogEntity
{
    public func toString() -> String
    {
        "{id: \(self.id), name: \(self.name), microchip: \(self.microchip), sex: \(self.sex) dateOfBirth: \(self.dateOfBirth), date: \(self.date), breed: \(self.breed), hairColor: \(String(describing: self.hairColor)), imageSize: \(self.image?.count)}"
    }
}
