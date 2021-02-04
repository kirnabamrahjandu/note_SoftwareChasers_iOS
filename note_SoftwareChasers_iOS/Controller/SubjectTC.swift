//
//  SubjectTC.swift
//  note_SoftwareChasers_iOS
//
//  Created by user186844 on 2/3/21.
//

import UIKit

class SubjectTC: UITableViewController {
    var arrSubject = [Subjects]()
    let dataAccess = DataAccess()
    override func viewDidLoad() {
        super.viewDidLoad()
        displaySubjects()
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
    func displaySubjects() {
        arrSubject.removeAll()
        arrSubject = dataAccess.retrieveSubjectFromCoreData()
        self.tableView.reloadData()
        //sortingByUserPreference()
        
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSubject.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SubjectTVC
        cell.lblSubject.text = arrSubject[indexPath.row].subject_name
        
        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let notes = dataAccess.retrieveDataFromCoreData(for: self.arrSubject[indexPath.row])
            if notes.count != 0{
                for note in notes{
                    dataAccess.deleteDataFromCoreData(with:note)
                    }
                }
               
            
            dataAccess.deleteSubjectFromCoreData(with: arrSubject[indexPath.row])
            arrSubject.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing{
           
            let alert = UIAlertController(title: "Update Subject", message: "", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.text = self.arrSubject[indexPath.row].subject_name
            }
            alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak alert] (_) in
                if let subject_name = alert?.textFields![0].text{
                    if subject_name != ""{
                        let dicToSave = [Constants.subject_name:subject_name] as [String : Any]
                        self.dataAccess.updateSubjectToCoreData(with: dicToSave, at: self.arrSubject[indexPath.row].subject_id!) { (_) in
                            self.displaySubjects()
                        }
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            NotificationCenter.default.post(name: Notification.Name( Constants.send_subject), object: arrSubject[indexPath.row], userInfo: nil)
                   self.navigationController?.popViewController(animated: true)
        }
    }
}
class SubjectTVC: UITableViewCell {
    @IBOutlet weak var lblSubject : UILabel!
}



