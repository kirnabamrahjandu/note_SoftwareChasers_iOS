//
//  Helper.swift
//  note_SoftwareChasers_iOS
//
//  Created by user191875 on 2/2/21.
//
import UIKit
import Foundation
class Helper {
    func getDateString(from date : Date, with format : String, calender : Bool = false) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        if calender{
            let calendar = Calendar.current
          
                dateFormatter.string(from: date)
            
        }
        return dateFormatter.string(from: date)
    }
}
extension UIColor{
    static let ThemeGreen = UIColor(red: 148/255, green: 23/255, blue: 81/255, alpha: 1)
}
