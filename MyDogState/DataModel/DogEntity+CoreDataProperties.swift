//
//  DogEntity+CoreDataProperties.swift
//  MyDogState
//
//  Created by Francesca Rossi on 21/12/23.
//
//

import Foundation
import CoreData


extension DogEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DogEntity> {
        return NSFetchRequest<DogEntity>(entityName: "DogEntity")
    }

    @NSManaged public var breed: String?
    @NSManaged public var date: Date?
    @NSManaged public var dateOfBirth: Date?
    @NSManaged public var hairColor: String?
    @NSManaged public var id: UUID?
    @NSManaged public var image: Data?
    @NSManaged public var microchip: String?
    @NSManaged public var name: String?
    @NSManaged public var sex: String?
    @NSManaged public var status: NSSet?

}

// MARK: Generated accessors for status
extension DogEntity {

    @objc(addStatusObject:)
    @NSManaged public func addToStatus(_ value: DogStatusInfoEntity)

    @objc(removeStatusObject:)
    @NSManaged public func removeFromStatus(_ value: DogStatusInfoEntity)

    @objc(addStatus:)
    @NSManaged public func addToStatus(_ values: NSSet)

    @objc(removeStatus:)
    @NSManaged public func removeFromStatus(_ values: NSSet)

}

extension DogEntity : Identifiable {

}
