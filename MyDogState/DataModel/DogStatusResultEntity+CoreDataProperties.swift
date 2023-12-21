//
//  DogStatusResultEntity+CoreDataProperties.swift
//  MyDogState
//
//  Created by Francesca Rossi on 21/12/23.
//
//

import Foundation
import CoreData


extension DogStatusResultEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DogStatusResultEntity> {
        return NSFetchRequest<DogStatusResultEntity>(entityName: "DogStatusResultEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var status: String?
    @NSManaged public var percentual: Double
    @NSManaged public var status_info: DogStatusInfoEntity?

}

extension DogStatusResultEntity : Identifiable {

}
