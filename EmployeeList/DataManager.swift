//
//  DataManager.swift
//  WorkingWithManagedObjects
//
//  Created by Mazharul Huq on 1/15/18.
//  Copyright © 2018 Mazharul Huq. All rights reserved.
//

import UIKit
import CoreData

class DataManager{
    var coreDataStack:CoreDataStack
    var managedObjectContext:NSManagedObjectContext
    
    init(dataModel:String){
        self.coreDataStack = CoreDataStack(modelName: dataModel)
        self.managedObjectContext = self.coreDataStack.managedObjectContext
    }
    
   //Creating records
    func createEmployee(firstName: String, lastName: String, dobString:String, sdString:String){
        
        //Create an entity and insert into context
        let employee = Employee(context: self.managedObjectContext)
        //Set attribute values
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        employee.firstName = firstName
        employee.lastName = lastName
        employee.startDate = formatter.date(from: sdString) as NSDate?
        employee.dateOfBirth = formatter.date(from: dobString) as NSDate?
        
        //Save context
        if !self.coreDataStack.saveContext(){
            print("Unable to create employee")
        }
    }
        
    func createDepartment(name: String){
        let department = Department(context: self.managedObjectContext)
            
        //Set attribute values
        department.name = name
        
        //Save context
        if !self.coreDataStack.saveContext(){
            print("Unable to create employee")
        }
    }
    
    func createRecords(){
        print("Here")
        createEmployee(firstName: "John", lastName: "Holder", dobString: "02-23-1945", sdString: "01-01-2001")
        createEmployee(firstName: "Jane", lastName: "Miller", dobString: "12-23-1940", sdString: "03-25-2010")
        createEmployee(firstName: "Richard", lastName: "Smith", dobString: "03-23-1955", sdString: "04-01-2011")
        createEmployee(firstName: "Joseph", lastName: "Handle", dobString: "10-13-1965", sdString: "01-01-2006")
        createEmployee(firstName: "Mary", lastName: "Alderman", dobString: "06-21-1943", sdString: "01-01-1995")
        createEmployee(firstName: "Henry", lastName: "Rockbottom", dobString: "05-03-1970", sdString: "06-15-2012")
        createEmployee(firstName: "Bob", lastName: "Rocker", dobString: "03-23-1975", sdString: "04-01-2015")
        createEmployee(firstName: "Bill", lastName: "Riley", dobString: "10-13-1945", sdString: "01-01-2002")
        createEmployee(firstName: "Mary", lastName: "Bobbins", dobString: "06-21-1949", sdString: "01-01-1998")
        createEmployee(firstName: "Andrew", lastName: "Jobs", dobString: "05-03-1975", sdString: "06-15-2014")
        
        createDepartment(name:"Accounting")
        createDepartment(name:"Human Resource")
        createDepartment(name:"Production")
        createDepartment(name:"Research")
    }
    
    
    //Fetching records from store
    func fetchEmployees()->[String]{
        var stringArray:[String] = []
        var employees:[Employee] = []
        
        let fetchRequest:NSFetchRequest<Employee> = Employee.fetchRequest()
        
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.short
        do{
             employees = try self.managedObjectContext.fetch(fetchRequest)
        }
        catch let error as NSError{
            print("Could not save \(error),(error.userInfo)")
            return stringArray
        }
        
        if employees.count < 1 {
            return stringArray
        }
    
        for i in 0...employees.count - 1 {
            var empString:String = ""
            let employee = employees[i]
            let firstName = employee.firstName ?? ""
            let lastName = employee.lastName ?? ""
            var dobString = ""
            var sdString = ""
            if let date = employee.dateOfBirth{
                dobString = formatter.string(from: date as Date )
            }
            
            if let date = employee.startDate{
                sdString = formatter.string(from: date as Date)
            }
            empString = firstName + " " + lastName + " Date of birth:" + dobString + " Start date:" + sdString
                
            if let department = employee.belongsTo{
                let name  = department.name ?? ""
                empString = empString + "\nBelongs to department:" + name
            }
            if let manager = employee.department {
                let name  = manager.name ?? ""
                empString = empString + "\nManager:" + name
            }
            stringArray.append(empString)
        }
        return stringArray
    }
    
    func fetchDepartments()->[String]{
        var stringArray:[String] = []
        var departments:[Department] = []
        let fetchRequest:NSFetchRequest<Department> = Department.fetchRequest()
        //Executes fetchRequest on managedObjectContext
        do{
            departments = try self.managedObjectContext.fetch(fetchRequest)
        }
        catch let error as NSError{
            print("Could not save \(error),(error.userInfo)")
            return stringArray
        }
        
        if departments.count < 1 {
            return stringArray
        }
        
        for i in 0...departments.count - 1 {
            var deptString = ""
            let department = departments[i]
            let name = department.name ?? ""
            deptString = "Department: " + name
                
            if let manager = department.manager{
                deptString = deptString + "\nManager:"
                let firstName = manager.firstName ?? ""
                let lastName = manager.lastName ?? ""
                deptString = deptString + firstName + " " + lastName
             }
                
            if let employees = department.employees {
                deptString = deptString + "\nEmployees:\n"
                for employee in employees{
                    let firstName = (employee as? Employee)?.firstName ?? ""
                    let lastName = (employee as? Employee)?.lastName ?? ""
                    deptString = deptString + firstName + " " + lastName + "\n"
                }
            }
                stringArray.append(deptString)
            }
    
        return stringArray
    }
    
    //Fetching single records
    
    func getEmployee(_ firstName: String, lastName:String)->Employee{
        var employee:Employee!
        let fetchRequest:NSFetchRequest<Employee> = Employee.fetchRequest()
        
        let firstPredicate = NSPredicate(format: "firstName = %@", firstName)
        let secondPredicate = NSPredicate(format: "lastName = %@", lastName)
        let compoundPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [firstPredicate,secondPredicate])
        fetchRequest.predicate = compoundPredicate
        
        do{
            let results = try self.managedObjectContext.fetch(fetchRequest)
            employee = results[0]
        }
        catch{
            let nserror = error as NSError
            print("Could not save \(nserror),(nserror.userInfo)")
        }
        return employee
    }
    
    func getDepartment(_ name: String)->Department{
        var department:Department!
        
        let fetchRequest:NSFetchRequest<Department> = Department.fetchRequest()
        
        let predicate = NSPredicate(format: "name = %@", name)
        fetchRequest.predicate = predicate
        
        do{
            let results = try self.managedObjectContext.fetch(fetchRequest)
            department = results[0] //results contains only one record
        }
        catch{
            let nserror = error as NSError
            print("Could not save \(nserror),(nserror.userInfo)")
        }
        return department
    }
    
    //Creating relationships
    func createToOneRelationship(){
        let employee1 = getEmployee("Jane", lastName: "Miller")
        let employee2 = getEmployee("Bill", lastName: "Riley")
        let employee3 = getEmployee("Bob", lastName: "Rocker")
        let department1 = getDepartment("Accounting")
        let department2 = getDepartment("Human Resource")
        let department3 = getDepartment("Production")
        department1.manager = employee1
        department2.manager = employee2
        department3.manager = employee3
        do {
            try self.managedObjectContext.save()
        } catch let error as NSError {
            print("Error creating relationship error:\(error)")
        }
    }
    
    func createToManyRelationship(){
        //Adding from One end
        let employee1 = getEmployee("John", lastName: "Holder")
        let employee2 = getEmployee("Mary", lastName: "Bobbins")
        let employee3 = getEmployee("Bill", lastName: "Riley")
        let department = getDepartment("Human Resource")
        
        employee1.belongsTo = department
        employee2.belongsTo = department
        employee3.belongsTo = department
        
        //Adding from Many end
        let employee4 = getEmployee("Jane", lastName: "Miller")
        let employee5 = getEmployee("Andrew", lastName: "Jobs")
        let employee6 = getEmployee("Joseph", lastName: "Handle")
        let department1 = getDepartment("Accounting")
        
        let employees1 = [employee4,employee5,employee6] as NSSet
        department1.addToEmployees(employees1)
        
        let employee7 = getEmployee("Richard", lastName: "Smith")
        let employee8 = getEmployee("Mary", lastName: "Alderman")
        let employee9 = getEmployee("Henry", lastName: "Rockbottom")
        let employee10 = getEmployee("Bob", lastName: "Rocker")
        let department2 = getDepartment("Production")
        
        let employees2 = [employee7,employee8,employee9,employee10] as NSSet
        department2.addToEmployees(employees2)
        
        do {
            try self.managedObjectContext.save()
        } catch let error as NSError {
            print("Error creating relationship error:\(error)")
        }
        
    }
    
    //Deleting records
    
    func deleteEmployee(){
        let employee:Employee!
        
        employee = getEmployee("William", lastName: "Johnson")
        self.managedObjectContext.delete(employee)
        
        //Save context
        do {
            try self.managedObjectContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func deleteDepartment(){
        let department:Department!
        
        department = getDepartment("Production")
        self.managedObjectContext.delete(department)
        
        //Save context
        do {
            try self.managedObjectContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    //Updating records
    
    func updateEmployee(){
        let employee:Employee!
        employee = getEmployee("John", lastName: "Holder")
        employee.firstName = "William"
        employee.lastName = "Johnson"
        
        //Save context
        do {
            try self.managedObjectContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    //Deleting relationship
    func deleteRelationship(){
        let department = getDepartment("Human Resource")
        department.employees = nil
        do {
            try self.managedObjectContext.save()
        } catch let error as NSError {
            print("Error deleting Person error:\(error)")
        }
    }

    
    
}
