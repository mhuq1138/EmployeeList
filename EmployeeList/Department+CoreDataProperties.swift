//
//  Department+CoreDataProperties.swift
//  EmployeeList
//
//  Created by Mazharul Huq on 2/24/18.
//  Copyright © 2018 Mazharul Huq. All rights reserved.
//
//

import Foundation
import CoreData


extension Department {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Department> {
        return NSFetchRequest<Department>(entityName: "Department")
    }

    @NSManaged public var name: String?
    @NSManaged public var employees: NSSet?
    @NSManaged public var manager: Employee?

}

// MARK: Generated accessors for employees
extension Department {

    @objc(addEmployeesObject:)
    @NSManaged public func addToEmployees(_ value: Employee)

    @objc(removeEmployeesObject:)
    @NSManaged public func removeFromEmployees(_ value: Employee)

    @objc(addEmployees:)
    @NSManaged public func addToEmployees(_ values: NSSet)

    @objc(removeEmployees:)
    @NSManaged public func removeFromEmployees(_ values: NSSet)

}
