//
//  Student+CoreDataProperties.swift
//  Rating table
//
//  Created by Maxorax on 30.03.2021.
//
//

import Foundation
import CoreData


extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student")
    }

    @NSManaged public var name: String
    @NSManaged public var lastName: String
    @NSManaged public var mark: Int16

}
