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

func updateNoteDataToCoreData(with data : [String:Any], at noteID : String, success:(Bool) ->()){
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
    fetchRequest.predicate = NSPredicate(format: "note_id = %@",noteID)
    
    let result = try! context.fetch(fetchRequest) as! [NSManagedObject]
    if result.count == 1{
        let note = result.first!
        for dic in data{
            note.setValue(dic.value, forKey: dic.key)
        }
        do {
            try context.save()
            success(true)
        }
        catch{
            success(false)
            print("Failed saving")
        }
    }
    
}
func retrieveDataFromCoreData(for subject:Subjects? = nil) -> [Note] {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
    if subject != nil{
        fetchRequest.predicate = NSPredicate(format: "subject_id = %@",subject!.subject_id!)
    }
    let result = try! context.fetch(fetchRequest) as! [NSManagedObject]
    var arrNotes = [Note]()
    for res in result{
        let note = Note()
        note.note_id = res.value(forKey: Constants.note_id) as? String
        note.note_title = res.value(forKey: Constants.note_title) as? String
        note.note_desc = res.value(forKey: Constants.note_desc) as? String
        note.date_created = res.value(forKey: Constants.date_created) as? Date
        note.date_modified = res.value(forKey: Constants.date_modified) as? Date
        note.lat = res.value(forKey: Constants.lat) as? Double
        note.long = res.value(forKey: Constants.long) as? Double
        note.picture = res.value(forKey: Constants.picture) as? Data
        note.subject_id = res.value(forKey: Constants.subject_id) as? String
        if note.note_id != nil{
            arrNotes.append(note)
        }
        
    }
    return arrNotes
    
}
func deleteDataFromCoreData(with data:Note){
    if  let id = data.note_id{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        fetchRequest.predicate = NSPredicate(format: "note_id = %@",id)
        
        let result = try! context.fetch(fetchRequest) as! [NSManagedObject]
        if result.count == 1{
            context.delete(result[0])
            do {
                try context.save()
            }
            catch{}
        }
    }
    
}

func retrieveSubjectFromCoreData() -> [Subjects] {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Subject")
    
    let result = try! context.fetch(fetchRequest) as! [NSManagedObject]
    var arrSubject = [Subjects]()
    for res in result{
        let subject = Subjects()
        subject.subject_id  = res.value(forKey: "subject_id") as? String
        subject.subject_name = res.value(forKey: "subject_name") as? String
        arrSubject.append(subject)
    }
    return arrSubject
}

func saveSubjectDataToCoreData(with data : [String:Any], success:(Bool) ->()){
    
    let entity = NSEntityDescription.entity(forEntityName: "Subject", in: context)
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
func deleteSubjectFromCoreData(with data:Subjects){
    if  let id = data.subject_id{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Subject")
        fetchRequest.predicate = NSPredicate(format: "subject_id = %@",id)
        
        let result = try! context.fetch(fetchRequest) as! [NSManagedObject]
        if result.count == 1{
            context.delete(result[0])
            do {
                try context.save()
            }
            catch{}
        }
    }
    
}
func updateSubjectToCoreData(with data : [String:Any], at subjectID : String, success:(Bool) ->()){
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Subject")
    fetchRequest.predicate = NSPredicate(format: "subject_id = %@",subjectID)
    
    let result = try! context.fetch(fetchRequest) as! [NSManagedObject]
    if result.count == 1{
        let note = result.first!
        for dic in data{
            note.setValue(dic.value, forKey: dic.key)
        }
        do {
            try context.save()
            success(true)
        }
        catch{
            success(false)
            print("Failed saving")
        }
    }
    
}
}
