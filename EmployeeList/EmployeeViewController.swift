//
//  EmployeeViewController.swift
//  WorkingWithManagedObjects
//
//  Created by Mazharul Huq on 1/15/18.
//  Copyright © 2018 Mazharul Huq. All rights reserved.
//

import UIKit

class EmployeeViewController: UIViewController {
    @IBOutlet var label: UILabel!
    @IBOutlet var textView: UITextView!
    
    var labelText = ""
    
    var employees:[String] = []
    
    var dataManager:DataManager!
    var empString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataManager = DataManager(dataModel: "EmployeeList")
        employees = self.dataManager.fetchEmployees()
        
        if employees.count > 0 {
            for i in 0...employees.count - 1 {
               self.empString = self.empString + employees[i] + "\n\n"
            }
        }
        self.label.text = "Employees after " + labelText
        self.textView.text = empString
       
    }
}
