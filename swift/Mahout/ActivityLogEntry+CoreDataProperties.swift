//
//  ActivityLogEntry+CoreDataProperties.swift
//  Mahout
//
//  Created by Chandrasekaran, Gopinath on 8/13/23.
//
//

import Foundation
import CoreData


extension ActivityLogEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ActivityLogEntry> {
        return NSFetchRequest<ActivityLogEntry>(entityName: "ActivityLogEntry")
    }

    @NSManaged public var id: String?
    @NSManaged public var planId: String?
    @NSManaged public var dailyRoutineId: String?
    @NSManaged public var userId: String?
    @NSManaged public var gymId: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var activityId: String?
    @NSManaged public var unitConfiguration: NSObject?
    @NSManaged public var endDate: Date?

}

extension ActivityLogEntry : Identifiable {

}
