//
//  Publications.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 3/24/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit

class Publications: UIView {
    
    let screenSize: CGRect = UIScreen.main.bounds
    let valuePro:CGFloat  = CGFloat(NSNumber.getPropotionalValueDevice())
    
    var lblTitle: UILabel!
    
    func drawBody(barHeight:CGFloat,title:String){
        
        self.backgroundColor = UIColor.init(hexString: GlobalConstants.color.iron)
        self.frame = CGRect(x: 0, y: 180*valuePro, width: screenSize.width, height: screenSize.height-180*valuePro-barHeight)
        
        let contentView:UIView = UIView()
        contentView.frame =  CGRect(x: 0, y: 0, width: screenSize.width, height: 25*valuePro)
        contentView.backgroundColor = UIColor.init(hexString: GlobalConstants.color.cobalto)

        lblTitle = UILabel()
        lblTitle.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 23*valuePro)
        lblTitle.titleColor(color: GlobalConstants.color.white,text:title)
        lblTitle.font = UIFont (name: GlobalConstants.font.helveticaRoundedBold, size: 14*valuePro)
        
        addSubview(contentView)
        contentView.addSubview(lblTitle)
        
    }
    func bodyNoData() {
        
    }
}
