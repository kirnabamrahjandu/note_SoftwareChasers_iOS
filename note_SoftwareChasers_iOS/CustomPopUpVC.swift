//
//  CustomPopUpVC.swift
//  note_SoftwareChasers_iOS
//
//  Created by user190379 on 2/3/21.
//

import UIKit
protocol subjectDelegate {
    func selectedSubject(name:Subjects)
    
}
protocol delegate {
    func seletedItem(selected:Int)
}

class CustomPopUpVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var mainViewY: NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!
    var arrItems = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

   

}
