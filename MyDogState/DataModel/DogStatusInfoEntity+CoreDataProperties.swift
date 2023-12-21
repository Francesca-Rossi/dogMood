//
//  DogStatusInfoEntity+CoreDataProperties.swift
//  MyDogState
//
//  Created by Francesca Rossi on 21/12/23.
//
//

import Foundation
import CoreData


extension DogStatusInfoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DogStatusInfoEntity> {
        return NSFetchRequest<DogStatusInfoEntity>(entityName: "DogStatusInfoEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var note: String?
    @NSManaged public var dog: DogEntity?
    @NSManaged public var status: NSSet?

}

// MARK: Generated accessors for status
extension DogStatusInfoEntity {

    @objc(addStatusObject:)
    @NSManaged public func addToStatus(_ value: DogStatusResultEntity)

    @objc(removeStatusObject:)
    @NSManaged public func removeFromStatus(_ value: DogStatusResultEntity)

    @objc(addStatus:)
    @NSManaged public func addToStatus(_ values: NSSet)

    @objc(removeStatus:)
    @NSManaged public func removeFromStatus(_ values: NSSet)

}

extension DogStatusInfoEntity : Identifiable {

}
