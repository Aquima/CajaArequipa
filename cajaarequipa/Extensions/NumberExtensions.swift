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
    
}
