//
//  Activity+CoreDataProperties.swift
//  Mahout
//
//  Created by Chandrasekaran, Gopinath on 8/13/23.
//
//

import Foundation
import CoreData


extension Activity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Activity> {
        return NSFetchRequest<Activity>(entityName: "Activity")
    }

    @NSManaged public var gymId: String?
    @NSManaged public var activityId: String?
    @NSManaged public var activityConfig: NSObject?

}

extension Activity : Identifiable {

}
