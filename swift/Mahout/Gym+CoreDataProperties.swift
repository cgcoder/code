//
//  Gym+CoreDataProperties.swift
//  Mahout
//
//  Created by Chandrasekaran, Gopinath on 8/13/23.
//
//

import Foundation
import CoreData


extension Gym {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Gym> {
        return NSFetchRequest<Gym>(entityName: "Gym")
    }

    @NSManaged public var gymName: String?
    @NSManaged public var id: String?
    @NSManaged public var gymInfo: String?
    @NSManaged public var gymWebsite: String?
    @NSManaged public var phone: String?

}

extension Gym : Identifiable {

}
