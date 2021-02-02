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
    var comingFromHome = false
    var note : Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //      setupUI()
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


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
