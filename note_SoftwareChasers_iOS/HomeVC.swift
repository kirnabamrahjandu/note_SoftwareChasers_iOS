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
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    func setupUI(){
        menuMainViewLeading.constant = -menuMainView.frame.width
        menuMainViewTrailing.constant = menuMainView.frame.width
        menuMainView.isHidden = true
        self.tableView.contentInset.bottom = 80
        self.navigationItem.title = "Notes"
        
    }
 
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
