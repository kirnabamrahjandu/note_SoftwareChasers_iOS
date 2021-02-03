//
//  HomeVC.swift
//  note_SoftwareChasers_iOS
//
//  Created by user190379 on 2/2/21.
//

import UIKit

class HomeVC: UIViewController {
    @IBOutlet weak var menuMainViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var menuMainViewLeading: NSLayoutConstraint!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var menuMainView: UIView!
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var searchBar : UISearchBar!
    var arrNotes = [Note]()
           override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        menuMainViewLeading.constant = -menuMainView.frame.width
        menuMainViewTrailing.constant = menuMainView.frame.width
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.menuMainView.isHidden = true
        //NotificationCenter.default.removeObserver(self, name: Notification.Name(Constants.send_subject), object: nil)
    
    
    
    }
    func setupUI(){
        menuMainViewLeading.constant = -menuMainView.frame.width
        menuMainViewTrailing.constant = menuMainView.frame.width
        menuMainView.isHidden = true
        self.tableView.contentInset.bottom = 80
        self.navigationItem.title = "Notes"
        
    }
    func sortingByUserPreference(){
        if let _ = UserDefaults.standard.value(forKey: "SortBy"){
            let key = UserDefaults.standard.integer(forKey: "SortBy")
            switch key {
            case 0:
                arrNotes = arrNotes.sorted(by: { $0.note_title! < $1.note_title!})
            case 1:
                arrNotes = arrNotes.sorted(by: { $0.note_title! > $1.note_title!})
            case 2:
                arrNotes = arrNotes.sorted(by: { $0.date_created!.timeIntervalSince1970 > $1.date_created!.timeIntervalSince1970 })
            default:
                print("Weird")
            }
        }
        else{
            arrNotes = arrNotes.sorted(by: { $0.date_created!.timeIntervalSince1970 > $1.date_created!.timeIntervalSince1970 })
        }
        tableView.reloadData()
    }
}

