//
//  ChangePasswordView.swift
//  cajaarequipa
//
//  Created by Nara on 7/27/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ChangePasswordView: UIView {
    let screenSize: CGRect = UIScreen.main.bounds
    let valuePro:CGFloat  = CGFloat(NSNumber.getPropotionalValueDevice())
    
    var lineEmail: UIView!
    var txtEmail: UITextField!
    
    var lineOldPassword: UIView!
    var txtOldPassword: UITextField!
    
    var lineNewPassword: UIView!
    var txtNewPassword: UITextField!
    
    var lineRePassword: UIView!
    var txtRePassword: UITextField!
    
    var lblTitleLabel: UILabel!
    var btnEnter: UIButton!
    
    var activityIndicatorView: NVActivityIndicatorView!
    
    func drawBody(){
        self.backgroundColor = UIColor.white
        // Drawing code
        lblTitleLabel = UILabel()
        lblTitleLabel.text = "Por favor, ingresa los siguientes datos para cambiar su contraseña."
        lblTitleLabel.textAlignment = .left
        lblTitleLabel.numberOfLines = 3
        lblTitleLabel.lineBreakMode = .byWordWrapping
        lblTitleLabel.textColor = UIColor.init(hexString: GlobalConstants.color.blackComment)
        
        txtEmail = UITextField()
        txtEmail.styleForm()
        txtEmail.placeholder = "Correo Electrónico o DNI" // "Ingrese su numero de DNI"
        txtEmail.clearButtonMode = .always
        txtEmail.autocorrectionType = UITextAutocorrectionType.no;
        
        lineEmail = UILabel()
        lineEmail.backgroundColor = UIColor.init(hexString: "cccccc")
        
        txtOldPassword = UITextField()
        txtOldPassword.styleForm()
        txtOldPassword.placeholder = "Contraseña Actual" // "Ingrese su numero de DNI"
        txtOldPassword.clearButtonMode = .always
        txtOldPassword.autocorrectionType = UITextAutocorrectionType.no;
        txtOldPassword.isSecureTextEntry = true
        
        lineOldPassword = UILabel()
        lineOldPassword.backgroundColor = UIColor.init(hexString: "cccccc")
        
        txtNewPassword = UITextField()
        txtNewPassword.styleForm()
        txtNewPassword.placeholder = "Nueva Contraseña" // "Ingrese su numero de DNI"
        txtNewPassword.clearButtonMode = .always
        txtNewPassword.autocorrectionType = UITextAutocorrectionType.no;
        txtNewPassword.isSecureTextEntry = true
        
        lineNewPassword = UILabel()
        lineNewPassword.backgroundColor = UIColor.init(hexString: "cccccc")
        
        txtRePassword = UITextField()
        txtRePassword.styleForm()
        txtRePassword.placeholder = "Repetir Nueva Contraseña" // "Ingrese su numero de DNI"
        txtRePassword.clearButtonMode = .always
        txtRePassword.autocorrectionType = UITextAutocorrectionType.no;
        txtRePassword.isSecureTextEntry = true
        
        lineRePassword = UILabel()
        lineRePassword.backgroundColor = UIColor.init(hexString: "cccccc")
        
        btnEnter = UIButton()
        btnEnter.fillTextColor(color: GlobalConstants.color.cancelRed, text: "Cambiar")
        addSubview(lblTitleLabel)
        
        addSubview(txtEmail)
        addSubview(lineEmail)
        
        addSubview(txtOldPassword)
        addSubview(lineOldPassword)
        
        addSubview(txtNewPassword)
        addSubview(lineNewPassword)
        
        addSubview(txtRePassword)
        addSubview(lineRePassword)
        
        addSubview(btnEnter)
    }
    func updateView(){
        
        lblTitleLabel.frame = CGRect(x: (self.frame.size.width-258*valuePro)/2, y: 0*valuePro, width: 258*valuePro, height: 39*valuePro)
        lblTitleLabel.font = UIFont (name: GlobalConstants.font.myriadProRegular, size: 14*valuePro)
        
        txtEmail.frame = CGRect(x: (self.frame.size.width-212*valuePro)/2, y: 44*valuePro, width: 212*valuePro, height: 44*valuePro)
        txtEmail.font = UIFont (name: GlobalConstants.font.myriadProRegular, size: 13*valuePro)
        
        lineEmail.frame = CGRect(x: (self.frame.size.width-258*valuePro)/2, y: 88*valuePro, width: 258*valuePro, height: 0.8*valuePro)
        // =============================
        txtOldPassword.frame = CGRect(x: (self.frame.size.width-212*valuePro)/2, y: 44*valuePro*2, width: 212*valuePro, height: 44*valuePro)
        txtOldPassword.font = UIFont (name: GlobalConstants.font.myriadProRegular, size: 13*valuePro)
        
        lineOldPassword.frame = CGRect(x: (self.frame.size.width-258*valuePro)/2, y: 88*valuePro*1.5, width: 258*valuePro, height: 0.8*valuePro)
        // =============================
        txtNewPassword.frame = CGRect(x: (self.frame.size.width-212*valuePro)/2, y: 44*valuePro*3, width: 212*valuePro, height: 44*valuePro)
        txtNewPassword.font = UIFont (name: GlobalConstants.font.myriadProRegular, size: 13*valuePro)
        
        lineNewPassword.frame = CGRect(x: (self.frame.size.width-258*valuePro)/2, y: 88*valuePro*2, width: 258*valuePro, height: 0.8*valuePro)
        // =============================
        txtRePassword.frame = CGRect(x: (self.frame.size.width-212*valuePro)/2, y: 44*valuePro*4, width: 212*valuePro, height: 44*valuePro)
        txtRePassword.font = UIFont (name: GlobalConstants.font.myriadProRegular, size: 13*valuePro)
        
        lineRePassword.frame = CGRect(x: (self.frame.size.width-258*valuePro)/2, y: 88*valuePro*2.5, width: 258*valuePro, height: 0.8*valuePro)
        
        btnEnter.frame = CGRect(x: (self.frame.size.width-258*valuePro)/2, y: lineRePassword.frame.origin.y+20*valuePro, width: 258*valuePro, height: 44*valuePro)
        btnEnter.layer.cornerRadius = 22*valuePro
        
        let frame =  CGRect(x: btnEnter.frame.origin.x + (btnEnter.frame.size.width-35*valuePro)/2, y:  btnEnter.frame.origin.y + (btnEnter.frame.size.height-35*valuePro)/2, width:35*valuePro, height: 35*valuePro)
        
        activityIndicatorView = NVActivityIndicatorView(frame: frame,
                                                        type: NVActivityIndicatorType(rawValue:1)!)
        activityIndicatorView.color = UIColor.init(hexString: GlobalConstants.color.cancelRed)
        activityIndicatorView.stopAnimating()
        
        addSubview(activityIndicatorView)
        
        btnEnter.addTarget(self, action: #selector(sendRecoveryRequest(sender:)), for: .touchUpInside)
        
    }
    func sendRecoveryRequest(sender:UIButton)  {
        sender.isHidden = true
        let frame =  CGRect(x: sender.frame.origin.x + (sender.frame.size.width-35*valuePro)/2, y:  sender.frame.origin.y + (sender.frame.size.height-35*valuePro)/2, width:35*valuePro, height: 35*valuePro)
        activityIndicatorView.frame = frame
        //validate all fields
        
        activityIndicatorView.startAnimating()
    }
}
