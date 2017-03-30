//
//  FooterPhoto.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 3/30/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit

class FooterPhoto: UIView,UITextFieldDelegate {

    
    let screenSize: CGRect = UIScreen.main.bounds
    let valuePro:CGFloat  = CGFloat(NSNumber.getPropotionalValueDevice())

    var previewViewContainer: UIImageView!
    var txtFooter: UITextField!
    
    func drawBody(){
        
        self.frame = CGRect(x: (screenSize.width-320*valuePro), y: 58*valuePro, width: 320*valuePro, height: 320*valuePro)
        
        previewViewContainer = UIImageView()
        previewViewContainer.frame = CGRect(x: 0, y: 0, width: 320*valuePro, height: 320*valuePro)
        addSubview(previewViewContainer)
        
        txtFooter = UITextField()
        txtFooter.frame =  CGRect(x: (screenSize.width-280*valuePro)/2, y: 20*valuePro, width: 280*valuePro, height: 44*valuePro)
        txtFooter.layer.cornerRadius = 22*valuePro
        txtFooter.layer.masksToBounds = true
        txtFooter.backgroundColor = UIColor.init(hexString: GlobalConstants.color.grayMedium)
        txtFooter.clearButtonMode = .always
        txtFooter.textColor = UIColor.init(hexString: GlobalConstants.color.cobalto)
        addSubview(txtFooter)
        
        let paddingView = UIView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
        txtFooter.leftView = paddingView;
        txtFooter.leftViewMode =  .always
        txtFooter.placeholder="Escribe un pie de foto"
        
//        let paddingRightView = UIView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
//        txtFooter.rightView = paddingRightView;
//        txtFooter.rightViewMode =  .whileEditing
        
    }
    func updateView(image:UIImage){
        previewViewContainer.image = image
        txtFooter.becomeFirstResponder()
    }
}
