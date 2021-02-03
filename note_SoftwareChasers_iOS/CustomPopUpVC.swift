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
    var arrSubject = [Subjects]()
    var seletedSubject = Subjects()
    var selected = -1
    var popupTitle = "Subjects"
    var delegate : delegate?
    var subjectDelegate : subjectDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        mainView.layer.cornerRadius = 10
        mainView.clipsToBounds = true
        mainViewY.constant = self.view.frame.height
        self.view.bringSubviewToFront(mainView)
        lblTitle.text = popupTitle
        
    }
    override func viewDidAppear(_ animated: Bool) {
        mainViewY.constant = 0
            self.view.layoutIfNeeded()
        
    }
    @IBAction func handleSubmit(_ sender: Any) {
        subjectDelegate?.selectedSubject(name: seletedSubject)
        delegate?.seletedItem(selected: selected)
        cancelPopUp()
    }
    
    @IBAction func handleCancel(_ sender: Any) {
        cancelPopUp()
    }
    @objc func cancelPopUp(){
        mainViewY.constant = self.view.frame.height
        
            self.view.layoutIfNeeded()
        
            self.dismiss(animated: false)
        }
        
    }
   
    
extension CustomPopUpVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrItems.count == 0 ? arrSubject.count : arrItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomPopUpTVC
        let label = arrItems.count == 0 ? arrSubject[indexPath.row].subject_name : arrItems[indexPath.row]
        cell.lblSubjectName.text = label
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arrItems.count == 0 {
            seletedSubject = arrSubject[indexPath.row]
        }
        else{
            selected = indexPath.row
        }
    }
    
    
}
class CustomPopUpTVC: UITableViewCell {
    @IBOutlet weak var lblSubjectName : UILabel!
}



   


