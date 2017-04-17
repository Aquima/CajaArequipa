//
//  Comment.swift
//  cajaarequipa
//
//  Created by Nara on 4/14/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit

class CommentList: UIView, UITextFieldDelegate {

    let screenSize: CGRect = UIScreen.main.bounds
    let valuePro:CGFloat  = CGFloat(NSNumber.getPropotionalValueDevice())
    
    var currentTexfield:UITextField = UITextField()
    func drawBody(barHeight:CGFloat){
        
        self.frame = CGRect(x:  (screenSize.width-320*valuePro)/2, y: 58*valuePro, width:320*valuePro, height: screenSize.height-58*valuePro-barHeight)
        self.backgroundColor = UIColor.init(hexString: GlobalConstants.color.white)
        
        let customComment:UIView = UIView()
        customComment.backgroundColor = UIColor.init(hexString: GlobalConstants.color.white)
        customComment.frame = CGRect(x: 0, y: self.frame.height-44*valuePro, width: self.frame.size.width, height: 44*valuePro)
        customComment.layer.borderColor = UIColor.init(hexString: GlobalConstants.color.grayLight).cgColor
        customComment.layer.borderWidth = 0.5
        self.addSubview(customComment)
        
        let textField = UITextField()
        textField.frame = CGRect(x: 0, y: 0, width: self.frame.size.width-100*valuePro, height: 44)
        textField.placeholder = "Agregar un comentario.."
        textField.font = UIFont(name: GlobalConstants.font.myriadProRegular, size: 14*valuePro)
        textField.textColor = UIColor.blue
        let paddingView = UIView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
        textField.leftView = paddingView;
        textField.leftViewMode =  .always
        
        let btnPost = UIButton()
        btnPost.frame = CGRect(x: self.frame.size.width-100*valuePro, y: 0, width: 100, height: 44)
        btnPost.setTitleColor(UIColor.init(hexString: GlobalConstants.color.blue), for: .normal)
        btnPost.setTitle("Publicar", for: .normal)
        btnPost.titleLabel?.font = UIFont(name: GlobalConstants.font.myriadProRegular, size: 13*valuePro)
        btnPost.setTitleColor(UIColor.init(hexString: GlobalConstants.color.blue), for: .normal)
        customComment.addSubview(textField)
        customComment.addSubview(btnPost)
        
        textField.inputAccessoryView = createInputAccessoryView()
      //  textField.becomeFirstResponder()
        
    }
    func createInputAccessoryView()->UIView{
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 44))
        customView.backgroundColor = UIColor.init(hexString: GlobalConstants.color.white)
        customView.layer.borderColor = UIColor.init(hexString: GlobalConstants.color.grayLight).cgColor
        customView.layer.borderWidth = 0.5
        
        let textField = UITextField()
        textField.frame = CGRect(x: 0, y: 0, width: self.frame.size.width-100*valuePro, height: 44)
        textField.placeholder = "Agregar un comentario.."
        textField.font = UIFont(name: GlobalConstants.font.myriadProRegular, size: 14*valuePro)
        textField.textColor = UIColor.blue
        let paddingView = UIView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
        textField.leftView = paddingView;
        textField.leftViewMode =  .always
        let btnPost = UIButton()
        btnPost.frame = CGRect(x: self.frame.size.width-100*valuePro, y: 0, width: 100, height: 44)
        btnPost.setTitle("Publicar", for: .normal)
        btnPost.titleLabel?.font = UIFont(name: GlobalConstants.font.myriadProRegular, size: 13*valuePro)
        btnPost.setTitleColor(UIColor.init(hexString: GlobalConstants.color.blue), for: .normal)
        customView.addSubview(textField)
        customView.addSubview(btnPost)
        
        return customView
    }
    
}
