//
//  PlanTemplate+CoreDataProperties.swift
//  Mahout
//
//  Created by Chandrasekaran, Gopinath on 8/13/23.
//
//

import Foundation
import CoreData


extension PlanTemplate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlanTemplate> {
        return NSFetchRequest<PlanTemplate>(entityName: "PlanTemplate")
    }

    @NSManaged public var id: String?
    @NSManaged public var variables: String?
    @NSManaged public var days: String?
    @NSManaged public var gymId: String?

}

extension PlanTemplate : Identifiable {

}
