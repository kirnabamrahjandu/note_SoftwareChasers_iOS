//
//  ImageNoteCell.swift
//  note_SoftwareChasers_iOS
//
//  Created by user191875 on 2/3/21.
//

import UIKit
import CoreData
class ImageNoteCell: UITableViewCell {
    @IBOutlet weak var lblTitle : UILabel!
     @IBOutlet weak var lblDate : UILabel!
     @IBOutlet weak var lblDesc : UILabel!
    let helper = Helper()
    
    @IBOutlet weak var noteImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupCell(with data:Note){
        lblTitle.text = data.note_title
        lblDesc.text = data.note_desc
        if let date = data.date_created{
            lblDate.text = helper.getDateString(from: date, with: "MMM d, yyyy", calender: true)
        }
        if let imageData = data.picture{
            noteImageView.image = UIImage(data: imageData)
        }
    }
}
