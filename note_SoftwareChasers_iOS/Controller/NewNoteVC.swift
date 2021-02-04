//
//  NewNoteVC.swift
//  note_SoftwareChasers_iOS
//
//  Created by user186844 on 2/3/21.
//

import UIKit
import CoreData
import CoreLocation

class NewNoteVC: UIViewController {
    @IBOutlet weak var btnInfo: UIButton!
    
    @IBOutlet weak var btnImageClose: UIButton!
    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    @IBOutlet weak var lblSubjectName: UILabel!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var imgAttachmentView: UIImageView!
    var audioString : String?
    var locationManager = CLLocationManager()
    var comingFromHome = false
    let dataAccesss = DataAccess()
    var note : Note?
    var selectedSubject : Subjects?
    var lat : Double = 0.0
    var long : Double = 0.0
    var arrSubjects = [Subjects]()
    
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
    }   // Do any additional setup after loading the view.
    
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
    func audioRecordingSet(file:String){
        audioString = file
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "record"{
            let vc = segue.destination as! RecordVC
            vc.newNoteVc = self
            if audioString != nil {
                print(audioString)
                vc.audioFilename = URL(string: audioString!)
            }
            
        }
    }
}

    
//MARK:- IBActions and Custom Functions
extension NewNoteVC{
    @IBAction func handleInsertImage(_ sender: Any){
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)

        actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertAction.Style.default, handler: {
            (alert:UIAlertAction!) -> Void in
            self.camera()
        }))

        actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))

        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

        self.present(actionSheet, animated: true, completion: nil)

    }
    func camera()
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        self.present(imagePicker, animated: true)

    }

    func photoLibrary()
    {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true)

    }
    @IBAction func handleSaveNote(_ sender: Any) {
        
        guard var strTitle = txtTitle.text else{return}
        guard let strDesc = txtDescription.text else{return}
        if strTitle == "" {
            strTitle = "Untitled Note"
        }
        var imageData : Data? = nil
        if imgAttachmentView.image != nil{
            imageData = imgAttachmentView.image?.jpegData(compressionQuality: 0.5)
        }
        if comingFromHome{
            var dicToUpdate = [Constants.note_title:strTitle,
                               Constants.note_desc:strDesc,
                               Constants.date_modified:Date()] as [String : Any]
            if imageData != nil{
                dicToUpdate.updateValue(imageData!, forKey: Constants.picture)
            }
            updateExistingNote(with: dicToUpdate)
        }
        else{ guard let subject_id = selectedSubject!.subject_id else {return}
            var dicToSave = [Constants.note_id:UUID().uuidString,
                                    Constants.note_title:strTitle,
                                    Constants.note_desc:strDesc,
                                    Constants.date_created:Date(),
                                    Constants.date_modified:Date(),
                                    Constants.subject_id : subject_id,
                                    Constants.lat: lat,
                                    Constants.long: long,
                                    "record":audioString ?? ""] as [String : Any]
                       
                   if imageData != nil{
                       dicToSave.updateValue(imageData!, forKey: Constants.picture)
                   }
            saveNewNote(with: dicToSave)
        }
        
        
    }


    @IBAction func handleSubjectChange(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "CustomPopUpVC") as! CustomPopUpVC
        vc.arrSubject = arrSubjects
        vc.subjectDelegate = self
        self.present(vc, animated: false)
    }
    
func saveNewNote(with dicToSave: [String:Any]){
        dataAccesss.saveNoteDataToCoreData(with: dicToSave) { (success) in
            if success{
                self.navigationController?.popViewController(animated: true)
            }
        }
}

    func updateExistingNote(with dicToUpdate: [String:Any]){
        guard let existingNote = note else{return}
        dataAccesss.updateNoteDataToCoreData(with: dicToUpdate, at: existingNote.note_id!) { (success) in
            if success{
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    func getUserCurrentLocation(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    func setupUI(){
        
    
        imgAttachmentView.layer.cornerRadius = 2
        
        arrSubjects = dataAccesss.retrieveSubjectFromCoreData()
        //setting default subject
        if let defaultSubject = arrSubjects.first(where: {$0.subject_name == "Default"}){
            selectedSubject = defaultSubject
            self.lblSubjectName.text = defaultSubject.subject_name
        }
    }
    func setValuesFromNote() {
        guard let existingNote = note else{return}
        guard let subject = arrSubjects.first(where: {$0.subject_id == existingNote.subject_id}) else{return}
        lblSubjectName.text = subject.subject_name
        txtTitle.text  = existingNote.note_title
        txtDescription.text = existingNote.note_desc
        audioString = existingNote.record
        
        if existingNote.picture != nil {
            imgHeight.constant = 200
            btnImageClose.isHidden = false
            imgAttachmentView.image = UIImage(data: existingNote.picture!)
        }
    }
}
extension NewNoteVC : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0] as CLLocation
        lat = location.coordinate.latitude
        long = location.coordinate.longitude
        manager.stopUpdatingLocation()
    }
}
extension NewNoteVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imgHeight.constant = 200
        btnImageClose.isHidden = false
        if let image = info[.editedImage] as? UIImage {
            imgAttachmentView.image = image
            
        }
        else if let image = info[.originalImage] as? UIImage {
            imgAttachmentView.image = image
        } else {
            print("Other source")
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
extension NewNoteVC : subjectDelegate{
    func selectedSubject(name: Subjects) {
        selectedSubject = name
        self.lblSubjectName.text = name.subject_name
    }
    
    
}
class MenuTVC: UITableViewCell {
    @IBOutlet weak var lblSubject : UILabel!
}
