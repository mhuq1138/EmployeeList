//
//  ViewController.swift
//  WorkingWithManagedObjects
//
//  Created by Mazharul Huq on 1/15/18.
//  Copyright © 2018 Mazharul Huq. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet var initializeButton: UIButton!
    @IBOutlet var toOneButton: UIButton!
    @IBOutlet var toManyButton: UIButton!
    @IBOutlet var updateButton: UIButton!
    @IBOutlet var deleteEmployeeButton: UIButton!
    @IBOutlet var deleteDepartmentButton: UIButton!
    
    @IBOutlet var deleteRelationshipButton: UIButton!
    
    var dataManager:DataManager!
    var isDirty = false
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var tabLabelText = ""
        
       guard let identifier = segue.identifier else{
            return
        }
        switch identifier{
        case "initializeSegue":
            tabLabelText = "initial Fetch"
            if isDirty {
                self.dataManager.coreDataStack.cleanEntity(entityName: "Employee")
                self.dataManager.coreDataStack.cleanEntity(entityName: "Department")
            }
            self.dataManager.createRecords()
            isDirty = true
            self.initializeButton.isEnabled = false
            self.toOneButton.isEnabled = true
            
        case "toOneSegue":
            tabLabelText = "creating to-One relationship"
            self.dataManager.createToOneRelationship()
            self.toOneButton.isEnabled = false
            self.toManyButton.isEnabled = true
        case "toManySegue":
            tabLabelText = "creating to-One and to-Many relationships"
            self.dataManager.createToManyRelationship()
            self.toManyButton.isEnabled = false
            self.updateButton.isEnabled = true
        case "updateSegue":
           tabLabelText = "updating a Employee record"
           self.dataManager.updateEmployee()
           self.updateButton.isEnabled = false
           self.deleteEmployeeButton.isEnabled = true
        case "deleteEmployeeSegue":
            tabLabelText = "deleting a Employee record"
            self.dataManager.deleteEmployee()
            self.deleteEmployeeButton.isEnabled = false
            self.deleteDepartmentButton.isEnabled = true
        case "deleteDepartmentSegue":
            tabLabelText = "deleting a Department record"
        self.dataManager.deleteDepartment()
        self.deleteDepartmentButton.isEnabled = false
        self.deleteRelationshipButton.isEnabled = true
        case "deleteRelationshipSegue":
            tabLabelText = "deleting a relationship"
            self.dataManager.deleteRelationship()
            self.deleteRelationshipButton.isEnabled = false
            self.initializeButton.isEnabled = true
        default:
            print("Hello")
            
        }
        
        let tvc = segue.destination as! UITabBarController
        let vc1 = tvc.viewControllers![0] as! EmployeeViewController
        let vc2 = tvc.viewControllers![1] as! DepartmentViewController
        vc1.labelText = tabLabelText
        vc2.labelText = tabLabelText
        
    }

}

