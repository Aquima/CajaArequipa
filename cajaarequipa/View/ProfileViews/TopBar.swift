//
//  TopBar.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 3/23/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit

class TopBar: UIView {
    
    let screenSize: CGRect = UIScreen.main.bounds
    let valuePro:CGFloat  = CGFloat(NSNumber.getPropotionalValueDevice())
    
    var btnLeft: UIButton!
    var btnRight: UIButton!
    
    var lblTitle: UILabel!
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.

    func drawBody(leftImage:UIImage,rightImage:UIImage,title:String){
        self.backgroundColor = UIColor.init(hexString: GlobalConstants.color.grayLight)
        
        self.frame = CGRect(x: 0, y: 18*valuePro, width: screenSize.width, height: 40*valuePro)
        btnLeft = UIButton()
        btnLeft.frame = CGRect(x: 0, y: 0, width: 40*valuePro, height: 40*valuePro)
        btnLeft.setImage(leftImage, for: .normal)
        btnLeft.backgroundColor = UIColor.clear
        addSubview(btnLeft)
        
        btnRight = UIButton()
        btnRight.frame = CGRect(x: screenSize.width-40*valuePro, y: 0, width: 40*valuePro, height: 40*valuePro)
        btnRight.setImage(rightImage, for: .normal)
        btnRight.backgroundColor = UIColor.clear
        addSubview(btnRight)
        
        lblTitle = UILabel()
        lblTitle.frame = CGRect(x: (screenSize.width-(screenSize.width-80*valuePro))/2, y: 0, width: screenSize.width-80*valuePro, height: 40*valuePro)
        lblTitle.titleColor(color: GlobalConstants.color.blue,text:title)
        lblTitle.font = UIFont (name: "HelveticaRounded-Bold", size: 14.5*valuePro)
        addSubview(lblTitle)
    }
}
