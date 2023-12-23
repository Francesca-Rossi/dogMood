//
//  EmotionalStateEntity+CoreDataProperties.swift
//  MyDogState
//
//  Created by Francesca Rossi on 21/12/23.
//
//

import Foundation
import CoreData


extension EmotionalStateEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EmotionalStateEntity> {
        return NSFetchRequest<EmotionalStateEntity>(entityName: "EmotionalStateEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var percentual: Double
    @NSManaged public var status: String?
    @NSManaged public var status_info: EmotionalCheckInfoEntity?

}

extension EmotionalStateEntity : Identifiable {

}
