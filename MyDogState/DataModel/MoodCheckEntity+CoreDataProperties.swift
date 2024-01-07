//
//  MoodCheckEntity+CoreDataProperties.swift
//  MyDogState
//
//  Created by Francesca Rossi on 07/01/24.
//
//

import Foundation
import CoreData


extension MoodCheckEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MoodCheckEntity> {
        return NSFetchRequest<MoodCheckEntity>(entityName: "MoodCheckEntity")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var note: String?
    @NSManaged public var image: Data?
    @NSManaged public var dog: DogEntity?

}

extension MoodCheckEntity : Identifiable {

}

extension MoodCheckEntity
{
    public func toString() -> String
    {
        "{id: \(self.id), date: \(self.date), note: \(self.note), dogID: \(self.dog?.id), dogName: \(self.dog?.name)}"
    }
}
