//
//  Movie+CoreDataProperties.swift
//  MovieFan
//
//  Created by Chandrasekaran, Gopinath on 8/9/23.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var name: String?
    @NSManaged public var year: Int32
    @NSManaged public var rating: Int16
    @NSManaged public var id: UUID?

}

extension Movie : Identifiable {

}
