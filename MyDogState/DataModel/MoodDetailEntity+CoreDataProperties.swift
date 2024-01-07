//
//  MoodDetailEntity+CoreDataProperties.swift
//  MyDogState
//
//  Created by Francesca Rossi on 07/01/24.
//
//

import Foundation
import CoreData


extension MoodDetailEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MoodDetailEntity> {
        return NSFetchRequest<MoodDetailEntity>(entityName: "MoodDetailEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var confidence: Float
    @NSManaged public var mood: String?
    @NSManaged public var status_info: MoodCheckEntity?

}

extension MoodDetailEntity : Identifiable {

}

extension MoodDetailEntity
{
    public func toString() -> String
    {
        "{id: \(self.id), status: \(self.mood), checkID: \(self.status_info?.id), percentual: \(self.confidence)}"
    }
}
