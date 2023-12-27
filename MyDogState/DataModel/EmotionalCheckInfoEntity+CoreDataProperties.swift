//
//  EmotionalCheckInfoEntity+CoreDataProperties.swift
//  MyDogState
//
//  Created by Francesca Rossi on 21/12/23.
//
//

import Foundation
import CoreData


extension EmotionalCheckInfoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EmotionalCheckInfoEntity> {
        return NSFetchRequest<EmotionalCheckInfoEntity>(entityName: "EmotionalCheckInfoEntity")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var note: String?
    @NSManaged public var dog: DogEntity?

}

extension EmotionalCheckInfoEntity : Identifiable {

}

extension EmotionalCheckInfoEntity
{
    public func toString() -> String
    {
        "{id: \(self.id), date: \(self.date), note: \(self.note), dogID: \(self.dog?.id), dogName: \(self.dog?.name)}"
    }
}
