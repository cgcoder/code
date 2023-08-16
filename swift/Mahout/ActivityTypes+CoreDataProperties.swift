//
//  ActivityTypes+CoreDataProperties.swift
//  Mahout
//
//  Created by Chandrasekaran, Gopinath on 8/13/23.
//
//

import Foundation
import CoreData


extension ActivityTypes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ActivityTypes> {
        return NSFetchRequest<ActivityTypes>(entityName: "ActivityTypes")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var info: String?
    @NSManaged public var image: String?
    @NSManaged public var unit: String?
    @NSManaged public var imageData: Data?

}

extension ActivityTypes : Identifiable {

}
