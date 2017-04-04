//
//  TopView.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 3/20/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit

class TopView: UIView {

    var imageView:UIImageView!
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
    }
 
    func updateView(){
        
        let valuePro:CGFloat  = CGFloat(NSNumber.getPropotionalValueDevice())
        imageView.frame = CGRect(x: (self.frame.size.width-183*valuePro)/2, y:10*valuePro + (self.frame.size.height-78*valuePro)/2, width: 183*valuePro, height: 78*valuePro)
        
    }
    func drawBody(){
        self.backgroundColor = UIColor.init(hexString: "002753")
        let valuePro:CGFloat  = CGFloat(NSNumber.getPropotionalValueDevice())
        
        imageView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        imageView.frame = CGRect(x: (self.frame.size.width-183*valuePro)/2, y:(self.frame.size.height-78*valuePro)/2, width: 183*valuePro, height: 78*valuePro)
        addSubview(imageView)
        
  

    }
}
