//
//  NewNoteVC.swift
//  note_SoftwareChasers_iOS
//
//  Created by user191875 on 2/2/21.
//

import UIKit

class NewNoteVC: UIViewController {
    @IBOutlet weak var btnInfo: UIButton!
    
    @IBOutlet weak var btnImageClose: UIButton!
    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    @IBOutlet weak var lblSubjectName: UILabel!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var imgAttachmentView: UIImageView!
    
    var locationManager = CLLocationManager()
    var lat : Double = 0.0
    var long : Double = 0.0
    var selectedSubject : Subjects?
    let dataAccesss = DataAccess()
    var note : Note?
    var arrSubjects = [Subjects]()
    var comingFromHome = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
           setupUI()
            btnInfo.isHidden = true
            if comingFromHome{
                setValuesFromNote()
                btnInfo.isHidden = false
            }
            else{
                getUserCurrentLocation()
            }
        // Do any additional setup after loading the view.
    }
    @IBAction func handleDelete(_ sender: Any) {
        imgHeight.constant = 20
        btnImageClose.isHidden = true
        imgAttachmentView.image = nil
    }
    @IBAction func handleInfo(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "MoreInfoTC") as! MoreInfoTC
        vc.note = note!
        vc.subject = lblSubjectName.text
        self.present(vc, animated: true, completion: nil)
    }
    
   

func setValuesFromNote() {
    guard let existingNote = note else{return}
    guard let subject = arrSubjects.first(where: {$0.subject_id == existingNote.subject_id}) else{return}
    lblSubjectName.text = subject.subject_name
    txtTitle.text  = existingNote.note_title
    txtDescription.text = existingNote.note_desc
    
    if existingNote.picture != nil {
        imgHeight.constant = 200
        btnImageClose.isHidden = false
        imgAttachmentView.image = UIImage(data: existingNote.picture!)
    }
}
    func getUserCurrentLocation(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kLocationAccuracy
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}
