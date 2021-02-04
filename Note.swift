//
//  Note.swift
//  note_SoftwareChasers_iOS
//
//  Created by user190379 on 2/3/21.
//
import  UIKit

class Note: NSObject {
    var note_id : String?
    var note_title : String?
    var note_desc : String?
    var date_created : Date?
    var date_modified : Date?
    var lat : Double?
    var long : Double?
    var picture : Data?
    var subject_id :String?
    var record : String?
}
class Subjects: NSObject {
    var subject_id :String?
    var subject_name : String?
}
