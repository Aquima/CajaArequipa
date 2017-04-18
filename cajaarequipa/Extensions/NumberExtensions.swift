//
//  NumberExtensions.swift
//  Chareety
//
//  Created by Raul Quispe on 12/24/16.
//  Copyright © 2016 Chareety. All rights reserved.
//

import UIKit

extension NSNumber {
    
    public static func getPropotionalValueDevice() -> NSNumber{
        let screenSize: CGRect = UIScreen.main.bounds
        let valueScreen:CGFloat = screenSize.size.height
        let integer:NSInteger = Int(valueScreen)
        switch integer {
            
        case 480:
            return 0.845;//S
            
        case 568:
            return 1;//5S
            
        case 667:
            return 1.174;//6
            
        case 736:
            return 1.295;//6Plus
            
        case 1024:
            return 1.8;//iPad
            
        case 1366:
            return 1.2;//iPad Pro
            
        case 1536:
            return 1.5;
            
        default:
            return 1;//iPad
            
        }
        
    }
    public static func getKeyboardSize() -> NSNumber{
        let screenSize: CGRect = UIScreen.main.bounds
        let valueScreen:CGFloat = screenSize.size.height
        let integer:NSInteger = Int(valueScreen)
        switch integer {
        case 568:
            return 274;//5&5S
            
        case 667:
            return 274;//6&7
            
        case 736:
            return 236;//6&7Plus
            
        default:
            return 224;//4s
            
        }
        
    }
    
}
extension UITableView {
    func scrollToBottom() {
        let sections = numberOfSections-1
        if sections >= 0 {
            let rows = numberOfRows(inSection: sections)-1
            if rows >= 0 {
                let indexPath = IndexPath(row: rows, section: sections)
                DispatchQueue.main.async { [weak self] in
                    self?.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
        }
    }
}
extension Date {
    func retrivePostTime() -> String {
        
        let currentDate: Date = Date()
        let distanceBetweenDates: TimeInterval = currentDate.timeIntervalSince(self)
        let theTimeInterval: TimeInterval = distanceBetweenDates
        let sysCalendar: Calendar = .current
        let date1: Date = Date()
        let date2: Date = Date(timeInterval: theTimeInterval, since: date1)
        let conversionInfo:DateComponents = sysCalendar.dateComponents([.hour, .minute , .day , .month , .second], from: date1, to: date2)
        
        var returnDate: String = "Hace instantes"
        if conversionInfo.month! > 0 { returnDate = String(format: "Hace %ld meses", conversionInfo.month!) }
        else if conversionInfo.day! > 0 { returnDate = String(format: "Hace %ld días", conversionInfo.day!) }
        else if conversionInfo.hour! > 0 { returnDate = String(format: "Hace %ld horas", conversionInfo.hour!) }
        else if conversionInfo.minute! > 0 { returnDate = String(format: "Hace %ld minutos", conversionInfo.minute!) }
        else if conversionInfo.second! > 0 { returnDate = String(format: "Hace %ld segundos", conversionInfo.second!) }
        
        return returnDate
    }
}
