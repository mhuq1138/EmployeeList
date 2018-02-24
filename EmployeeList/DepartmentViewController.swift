//
//  DepartmentViewController.swift
//  WorkingWithManagedObjects
//
//  Created by Mazharul Huq on 1/15/18.
//  Copyright © 2018 Mazharul Huq. All rights reserved.
//

import UIKit

class DepartmentViewController: UIViewController {

    @IBOutlet var label: UILabel!
    @IBOutlet var textView: UITextView!
    
    var labelText = ""
    
    var departments:[String] = []
    
    var dataManager:DataManager!
    var deptString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataManager = DataManager(dataModel: "EmployeeList")
        departments = self.dataManager.fetchDepartments()
        if departments.count > 0{
            for i in 0...departments.count - 1 {
                self.deptString = self.deptString + departments[i] + "\n\n"
            }
        }
        self.label.text = "Departments after " + labelText
        self.textView.text = deptString
    }

}
