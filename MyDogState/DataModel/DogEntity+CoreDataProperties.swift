//
//  DogEntity+CoreDataProperties.swift
//  MyDogState
//
//  Created by Francesca Rossi on 07/01/24.
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

}

extension DogEntity : Identifiable {

}
