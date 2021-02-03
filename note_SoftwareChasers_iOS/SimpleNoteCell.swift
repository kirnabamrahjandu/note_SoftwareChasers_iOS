//
//  SimpleNoteCell.swift
//  note_SoftwareChasers_iOS
//
//  Created by user186818 on 2/3/21.
import UIKit
import CoreData

class SimpleNoteCell: UITableViewCell {
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblDate : UILabel!
    @IBOutlet weak var lblDesc : UILabel!
    let helper = Helper()

    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
}
