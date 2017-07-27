//
//  RecoveryView.swift
//  cajaarequipa
//
//  Created by Nara on 7/27/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class RecoveryView: UIView {
    let screenSize: CGRect = UIScreen.main.bounds
    let valuePro:CGFloat  = CGFloat(NSNumber.getPropotionalValueDevice())
    
    var lineEmail: UIView!
    var txtEmail: UITextField!
    var lblTitleLabel: UILabel!
    var btnEnter: UIButton!
    
    var activityIndicatorView: NVActivityIndicatorView!
    
    func drawBody(){
        self.backgroundColor = UIColor.white
        // Drawing code
        lblTitleLabel = UILabel()
        lblTitleLabel.text = "Por favor, ingresa el correo electronico o DNI para recuperar contraseña."
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
        
        btnEnter = UIButton()
        btnEnter.fillTextColor(color: GlobalConstants.color.blue, text: "Recuperar Contraseña")
        addSubview(lblTitleLabel)
        addSubview(txtEmail)
        addSubview(lineEmail)
        addSubview(btnEnter)
    }
    func updateView(){
        
        lblTitleLabel.frame = CGRect(x: (self.frame.size.width-258*valuePro)/2, y: 0*valuePro, width: 258*valuePro, height: 39*valuePro)
        lblTitleLabel.font = UIFont (name: GlobalConstants.font.myriadProRegular, size: 14*valuePro)
        
        txtEmail.frame = CGRect(x: (self.frame.size.width-212*valuePro)/2, y: 44*valuePro, width: 212*valuePro, height: 44*valuePro)
        txtEmail.font = UIFont (name: GlobalConstants.font.myriadProRegular, size: 13*valuePro)
        
        lineEmail.frame = CGRect(x: (self.frame.size.width-258*valuePro)/2, y: 88*valuePro, width: 258*valuePro, height: 0.8*valuePro)
        
        btnEnter.frame = CGRect(x: (self.frame.size.width-258*valuePro)/2, y: 108*valuePro, width: 258*valuePro, height: 44*valuePro)
        btnEnter.layer.cornerRadius = 22*valuePro
        
        let frame =  CGRect(x: btnEnter.frame.origin.x + (btnEnter.frame.size.width-35*valuePro)/2, y:  btnEnter.frame.origin.y + (btnEnter.frame.size.height-35*valuePro)/2, width:35*valuePro, height: 35*valuePro)
        
        activityIndicatorView = NVActivityIndicatorView(frame: frame,
                                                        type: NVActivityIndicatorType(rawValue:1)!)
        activityIndicatorView.color = UIColor.init(hexString: "002753")
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
