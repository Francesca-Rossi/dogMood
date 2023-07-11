//
//  Dog+CoreDataProperties.swift
//  MyDogState
//
//  Created by Francesca Rossi on 11/07/23.
//
//

import Foundation
import CoreData
import SwiftUI


extension Dog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dog> {
        return NSFetchRequest<Dog>(entityName: "Dog")
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

extension Dog : Identifiable {

}

extension Dog
{
    func getSexColor()-> Color
    {
        switch sex
        {
        case sexType.Boy: return .blue
        case sexType.Girl: return .pink
        default:
            return .blue
        }
        
    }
}
