//
//  DailyRoutine+CoreDataProperties.swift
//  Mahout
//
//  Created by Chandrasekaran, Gopinath on 8/13/23.
//
//

import Foundation
import CoreData


extension DailyRoutine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyRoutine> {
        return NSFetchRequest<DailyRoutine>(entityName: "DailyRoutine")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var info: String?
    @NSManaged public var duration: Int16
    @NSManaged public var activities: String?

}

extension DailyRoutine : Identifiable {

}
