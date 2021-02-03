//
//  HomeVC.swift
//  note_SoftwareChasers_iOS
//
//  Created by user190379 on 2/2/21.
//

import UIKit
import CoreData

class HomeVC: UIViewController {
    @IBOutlet weak var menuMainViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var menuMainViewLeading: NSLayoutConstraint!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var menuMainView: UIView!
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var searchBar : UISearchBar!
   
    let dataAccess = DataAccess()
    let arrMenu = ["All Subjects","Subjects"]
    let arrSortTypes = ["Title A-Z","Title Z-A","Date"]
    var arrNotes = [Note]()
    var filterArrNotes = [Note]()
    var searchInProgress = false
    var selected_subject : Subjects?
           override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        displayNotes()
        menuMainViewLeading.constant = -menuMainView.frame.width
        menuMainViewTrailing.constant = menuMainView.frame.width
        NotificationCenter.default.addObserver(self, selector: #selector(handleSubjectSort(noti:)), name:
        Notification.Name(Constants.send_subject), object: nil)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.menuMainView.isHidden = true
        //NotificationCenter.default.removeObserver(self, name: Notification.Name(Constants.send_subject), object: nil)
    }
}
extension HomeVC{
    @objc func handleSubjectSort(noti:Notification){
        self.selected_subject = noti.object as? Subjects
        displayNotes()
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
    func setupUI(){
        menuMainViewLeading.constant = -menuMainView.frame.width
        menuMainViewTrailing.constant = menuMainView.frame.width
        menuMainView.isHidden = true
        self.tableView.contentInset.bottom = 80
        self.navigationItem.title = "Notes"
        self.addDefaultSubject()
        
    }
    func addDefaultSubject() {
        let subjects = dataAccess.retrieveSubjectFromCoreData()
        if subjects.count == 0 {
            dataAccess.saveSubjectDataToCoreData(with: [Constants.subject_id: UUID().uuidString,Constants.subject_name:"Default"]) { (_) in
                print("Default SUBJECT ADDED")
            }
        }
    }
    
    func displayNotes() {
        arrNotes.removeAll()
        arrNotes = dataAccess.retrieveDataFromCoreData()
        if selected_subject != nil {
            arrNotes = arrNotes.filter({$0.subject_id == selected_subject!.subject_id})
        }
        sortingByUserPreference()
        
    }
    func searchWithKeyword(key:String){
        searchInProgress = true
        filterArrNotes.removeAll()
        let set = Set(arrNotes.filter({($0.note_title?.contains(key))!}) + arrNotes.filter({($0.note_desc?.contains(key))!}))
        filterArrNotes = Array(set)
        tableView.reloadData()
    }
    

    @IBAction func handleSearchBar(){
        view.layoutIfNeeded()
        if topViewHeight.constant == 0{
            
            topViewHeight.constant = 56
        }
        else{
            topViewHeight.constant = 0
            searchInProgress = false
            tableView.reloadData()
        }
       
        
    }
    
    @IBAction func handleHideMenu(_ sender: Any) {
        menuMainViewLeading.constant = -menuMainView.frame.width
        menuMainViewTrailing.constant = menuMainView.frame.width
        
            self.menuMainView.isHidden = true
        
        
    }
    @IBAction func handleShowMenu(_ sender: Any) {
        if menuMainViewLeading.constant == 0 {
            menuMainViewLeading.constant = -menuMainView.frame.width
            menuMainViewTrailing.constant = menuMainView.frame.width
                self.view.layoutIfNeeded()
                self.menuMainView.isHidden = true
            
        }
        else{
            menuMainView.isHidden = false
            menuMainViewLeading.constant = 0
            menuMainViewTrailing.constant = 0
                self.view.layoutIfNeeded()
            
        }
        
    }
}
extension HomeVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(label)
        label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15).isActive = true
        label.widthAnchor.constraint(equalToConstant: headerView.frame.width).isActive = true
        label.heightAnchor.constraint(equalToConstant: headerView.frame.height).isActive = true
        label.text = selected_subject != nil ? selected_subject?.subject_name : "All Subjects"
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 16)
        label.textColor = UIColor.darkGray
        headerView.backgroundColor = UIColor.white
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == menuTableView{
            return 0
        }
        return 30
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == menuTableView{
            return 60
        }
        return 140
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == menuTableView{
            return arrMenu.count
        }
        return searchInProgress ? filterArrNotes.count : arrNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == menuTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuTVC
            cell.lblSubject.text = arrMenu[indexPath.row]
            return cell
        }
        else{
            if (searchInProgress ? filterArrNotes[indexPath.row] : arrNotes[indexPath.row]).picture != nil{
                let imageCell = tableView.dequeueReusableCell(withIdentifier: Constants.ImageNoteCell, for: indexPath) as! ImageNoteCell
                imageCell.setupCell(with: searchInProgress ? filterArrNotes[indexPath.row] : arrNotes[indexPath.row])
                return imageCell
            }
            else{
                let simpleCell = tableView.dequeueReusableCell(withIdentifier: Constants.SimpleNoteCell, for: indexPath) as! SimpleNoteCell
                simpleCell.setupCell(with: searchInProgress ? filterArrNotes[indexPath.row] : arrNotes[indexPath.row])
                return simpleCell
            }
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == menuTableView{
            switch indexPath.row {
                case 0:
                selected_subject = nil
                displayNotes()
                handleShowMenu(self)
            case 1:
                let vc  = storyboard?.instantiateViewController(identifier: "SubjectTC") as! SubjectTC
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                print("")
            }
        }
        else{
            let note = searchInProgress ? filterArrNotes[indexPath.row] : arrNotes[indexPath.row]
            let vc = self.storyboard?.instantiateViewController(identifier: "NewNoteVC") as! NewNoteVC
            vc.note = note
            vc.comingFromHome = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if tableView == menuTableView{
            return
        }
        else{
            if editingStyle == .delete{
                dataAccess.deleteDataFromCoreData(with: arrNotes[indexPath.row])
                arrNotes.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
}
extension HomeVC : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchWithKeyword(key: searchText)
    }
}
extension HomeVC : delegate{
    func seletedItem(selected: Int) {
        UserDefaults.standard.set(selected, forKey: "SortBy")
        sortingByUserPreference()
    }
    
    
}



