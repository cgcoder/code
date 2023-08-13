//
//  User+CoreDataProperties.swift
//  Mahout
//
//  Created by Chandrasekaran, Gopinath on 8/13/23.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var email: String?

}

extension User : Identifiable {

}
