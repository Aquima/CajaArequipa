//
//  ColorExtensions.swift
//  Chareety
//
//  Created by Raul Quispe on 12/25/16.
//  Copyright © 2016 Chareety. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }

}
extension UIView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
extension UITextField {
    func styleForm() {
        
        self.textAlignment = .left
        self.backgroundColor = UIColor.clear
        self.textColor = UIColor.init(hexString: GlobalConstants.color.cobalto)
    
    }

    
}
extension UIButton {

    func borderTextColor(color:String,text:String) {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.init(hexString: color).cgColor
        self.backgroundColor = UIColor.clear

        self.setTitleColor(UIColor.init(hexString:color), for: .normal)
        self.setTitle(text, for: .normal)
 
    }
    func fillTextColor(color:String,text:String) {
        self.backgroundColor = UIColor.init(hexString: color)
        self.setTitleColor(UIColor.white, for: .normal)
        self.setTitle(text, for: .normal)
    }
    func titleTextColor(color:String,text:String) {
       
        self.setTitleColor(UIColor.init(hexString:color), for: .normal)
        self.setTitle(text, for: .normal)
    }
}
extension UILabel {
    func titleColor(color:String, text:String){
        self.textColor = UIColor.init(hexString: color)
        self.textAlignment = .center
        self.text = text
    }
}
extension String {
    func getIDFromFireBase() -> String {
        
        let split = self.components(separatedBy: "@")
        let firstPart = split[0]
        let domain:String = split[1]
        let newDomain = domain.replacingOccurrences(of: ".", with: "_dot_")
        return firstPart + "_at_" + newDomain
        
    }
    func getUserName() -> String {
        
        let split = self.components(separatedBy: " ")
        let firstName = split.last
        if split.count == 4 {
            return split[2]
        }else{
            return firstName!
        }
        
    }
    func getFirstName() -> String {
        
        let split = self.components(separatedBy: " ")
        let firstName = split.last
        if split.count == 4 {
            return split[2] + " "  + firstName!
        }else{
            return firstName!
        }
      
    }
    func getLastName() -> String {
        
        let split = self.components(separatedBy: " ")

        return split.first! + " "  + split[1]
   
    }
    func isValidEmail() -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}
extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
