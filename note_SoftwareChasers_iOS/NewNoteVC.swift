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
    
    var note : Note?

    override func viewDidLoad() {
        super.viewDidLoad()

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
}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


