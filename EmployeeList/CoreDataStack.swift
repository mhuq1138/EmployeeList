//
//  CoreDataStack.swift
//  CoreDataStack
//
//  Created by Mazharul Huq on 1/13/18.
//  Copyright © 2018 Mazharul Huq. All rights reserved.
//

import CoreData

class CoreDataStack{
    
    private let modelName:String
    
    init(modelName:String){
        self.modelName = modelName
    }
    
    private lazy var storeContainer:NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores{ (storeDescription, error)
            in
            if let error = error as NSError?{
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    func saveContext ()->Bool {
        guard managedObjectContext.hasChanges else { return false }
        do {
            try managedObjectContext.save()
            return true
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
            return false
        }
    }
    
    func cleanEntity(entityName:String){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:entityName)
        let objects: [AnyObject]?
        do {
            objects = try self.managedObjectContext.fetch(fetchRequest)
            
        } catch _ {
            objects = nil
        }
        for object in objects as! [NSManagedObject] {
            self.managedObjectContext.delete(object)
        }
    }
   
}
