//
//  DataAccess.swift
//  note_SoftwareChasers_iOS
//
//  Created by user186818 on 2/2/21.
//

import Foundation
import UIKit
import CoreData
class DataAccess {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext!
    init() {
        context = appDelegate.persistentContainer.viewContext
    }
    func saveNoteDataToCoreData(with data : [String:Any], success:(Bool) ->()){
        
        let entity = NSEntityDescription.entity(forEntityName: "Notes", in: context)
        let newNote = NSManagedObject(entity: entity!, insertInto: context)
        for dic in data{
            newNote.setValue(dic.value, forKey: dic.key)
        }
        do {
            try context.save()
            success(true)
        } catch {
            success(false)
            print("Failed saving")
        }
    }
}
