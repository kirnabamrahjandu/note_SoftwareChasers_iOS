//
//  SubjectTC.swift
//  note_SoftwareChasers_iOS
//
//  Created by user186844 on 2/3/21.
//

import UIKit

class SubjectTC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.allowsSelectionDuringEditing = true
        let editBtn = UIBarButtonItem(image: UIImage(named: "edit") , style: .plain, target: self, action: #selector(handleEditing))
        self.navigationItem.rightBarButtonItem = editBtn
        
    }
  

  

@objc func handleEditing(){
    if self.tableView.isEditing == true
       {
           self.tableView.isEditing = false
        self.navigationItem.rightBarButtonItems = nil
        let editBtn = UIBarButtonItem(image: UIImage(named: "edit") , style: .plain, target: self, action: #selector(handleEditing))
        self.navigationItem.rightBarButtonItem = editBtn
       }
       else
       {
        self.navigationItem.rightBarButtonItems = nil
        let editBtn = UIBarButtonItem(image: UIImage(named: "done") , style: .plain, target: self, action: #selector(handleEditing))
        let addBtn = UIBarButtonItem(image: UIImage(named: "add"), style: .plain, target: self, action: #selector(handleAdd))
        self.navigationItem.rightBarButtonItems = [editBtn,addBtn]
           self.tableView.isEditing = true
       }
}


@objc func handleAdd() {
    let alert = UIAlertController(title: "Add Subject", message: "", preferredStyle: .alert)
    alert.addTextField { (textField) in
        textField.placeholder = "Enter Subject"
    }
}
}
