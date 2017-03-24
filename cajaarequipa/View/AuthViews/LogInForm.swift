//
//  LogInForm.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 3/20/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Firebase

enum inputType{
    case keyMail
    case keyPassword
}
protocol LogInFormDelegate {
    func callLogIn(email:String,password:String)
    func goToRegister()
    func goToForget()
}
class LogInForm: UIView, UITextFieldDelegate {
    
    var delegate:LogInFormDelegate?
    
    let screenSize: CGRect = UIScreen.main.bounds
    let valuePro:CGFloat  = CGFloat(NSNumber.getPropotionalValueDevice())
    
    var lblTitleLabel: UILabel!

    var txtEmail: UITextField!
    var txtPassword: UITextField!
    
    var btnEnter: UIButton!
    var btnRegister: UIButton!
    var btnForget: UIButton!
    
    var lineEmail: UIView!
    var linePassword: UIView!
    
    var inputList:[UITextField] = []
    
    var activityIndicatorView: NVActivityIndicatorView!
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    func drawBody(){
        self.backgroundColor = UIColor.white
        // Drawing code
        lblTitleLabel = UILabel()
        lblTitleLabel.titleColor(color: GlobalConstants.color.blue,text:"INICIAR SESIÓN")
        
        txtEmail = UITextField()
        txtEmail.styleForm()
        txtEmail.placeholder = "Correo Electrónico"
        txtPassword = UITextField()
        txtPassword.styleForm()
        txtPassword.placeholder = "Contraseña"
        btnEnter = UIButton()
        btnRegister = UIButton()
        btnForget = UIButton()
        
        lineEmail = UIView()
        lineEmail.backgroundColor = UIColor.init(hexString: "cccccc")
        linePassword = UIView()
        linePassword.backgroundColor = UIColor.init(hexString: "cccccc")
        
        btnRegister.borderTextColor(color: "5297D1",text: "Resgitrarse")
        btnEnter.fillTextColor(color: "002753", text: "Iniciar Sesión")
        btnForget.titleTextColor(color: "002753", text: "¿Olvido su contraseña?")
        
        addSubview(lblTitleLabel)
        addSubview(txtEmail)
        addSubview(txtPassword)
        addSubview(btnEnter)
        addSubview(btnRegister)
        addSubview(btnForget)
        addSubview(lineEmail)
        addSubview(linePassword)
        
    }
    func updateView(){
        
        lblTitleLabel.frame = CGRect(x: (self.frame.size.width-258*valuePro)/2, y: 10*valuePro, width: 258*valuePro, height: 17*valuePro)
        lblTitleLabel.font = UIFont (name: "HelveticaRounded-Bold", size: 13*valuePro)
        
        txtEmail.frame = CGRect(x: (self.frame.size.width-212*valuePro)/2, y: 44*valuePro, width: 212*valuePro, height: 44*valuePro)
        txtEmail.font = UIFont (name: "MyriadPro-Regular", size: 13*valuePro)
        
        lineEmail.frame = CGRect(x: (self.frame.size.width-258*valuePro)/2, y: 88*valuePro, width: 258*valuePro, height: 0.8*valuePro)
        
        txtPassword.frame = CGRect(x: (self.frame.size.width-212*valuePro)/2, y: 88*valuePro, width: 212*valuePro, height: 44*valuePro)
        txtPassword.font = UIFont (name: "MyriadPro-Regular", size: 13*valuePro)
        txtPassword.isSecureTextEntry = true
        
        linePassword.frame = CGRect(x: (self.frame.size.width-258*valuePro)/2, y: 132*valuePro, width: 258*valuePro, height: 0.8*valuePro)
        
        btnEnter.frame = CGRect(x: (self.frame.size.width-258*valuePro)/2, y: 160*valuePro, width: 258*valuePro, height: 44*valuePro)
        btnEnter.layer.cornerRadius = 22*valuePro

        let frame =  CGRect(x: btnEnter.frame.origin.x + (btnEnter.frame.size.width-35*valuePro)/2, y:  btnEnter.frame.origin.y + (btnEnter.frame.size.height-35*valuePro)/2, width:35*valuePro, height: 35*valuePro)
        
        activityIndicatorView = NVActivityIndicatorView(frame: frame,
                                                        type: NVActivityIndicatorType(rawValue:1)!)
        activityIndicatorView.color = UIColor.init(hexString: "002753")
        activityIndicatorView.stopAnimating()
        
        addSubview(activityIndicatorView)
        
        btnRegister.frame = CGRect(x: (self.frame.size.width-258*valuePro)/2, y: 222*valuePro, width: 258*valuePro, height: 44*valuePro)
        btnRegister.layer.cornerRadius = 22*valuePro
        btnRegister.layer.borderWidth = 0.5

        btnEnter.titleLabel?.font = UIFont (name: "HelveticaRounded-Bold", size: 14*valuePro)
        btnRegister.titleLabel?.font = UIFont (name: "HelveticaRounded-Bold", size: 14*valuePro)

        btnForget.frame = CGRect(x: (self.frame.size.width-258*valuePro)/2, y: 300*valuePro, width: 258*valuePro, height: 44*valuePro)
        btnForget.titleLabel?.font = UIFont (name: "HelveticaRounded-Bold", size: 14*valuePro)
        
        inputList.append(txtEmail)
        inputList.append(txtPassword)
        
        //add Actions
        btnRegister.addTarget(self, action: #selector(pressRegisterOn(sender:)), for: .touchUpInside)
        btnEnter.addTarget(self, action: #selector(loginManualValidate(sender:)), for: .touchUpInside)
        btnForget.addTarget(self, action: #selector(pressForgetOn(sender:)), for: .touchUpInside)
        
    }
    // MARK: - UITextField
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

        switch textField.tag {
        case inputType.keyMail.hashValue:
           
            break
        case inputType.keyPassword.hashValue:

            break
        default:
            return true
        }
        return true
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        switch textField.tag {
        case inputType.keyMail.hashValue:
   
            let inputText:UITextField = self.inputList[inputType.keyPassword.hashValue]
            inputText.becomeFirstResponder()
            break
        case inputType.keyPassword.hashValue:

            textField.resignFirstResponder()
            break
        default:
            return true
        }
        return true
    }
    func resignFirstResponderList(){
        
        for inputUX in self.inputList {
            let inputTxt = inputUX
            inputTxt.resignFirstResponder()
        }

    }
    func loginManualValidate(sender:UIButton)  {
        sender.isHidden = true
        let frame =  CGRect(x: sender.frame.origin.x + (sender.frame.size.width-35*valuePro)/2, y:  sender.frame.origin.y + (sender.frame.size.height-35*valuePro)/2, width:35*valuePro, height: 35*valuePro)
        activityIndicatorView.frame = frame
        //validate all fields

        activityIndicatorView.startAnimating()
        let inputTextMail:UITextField = self.inputList[inputType.keyMail.hashValue]
        let inputTextPassword:UITextField = self.inputList[inputType.keyPassword.hashValue]
        btnEnter.isHidden = true
        
        if inputTextMail.text != "" && inputTextPassword.text != "" {
            
            let email = inputTextMail.text
            let password = inputTextPassword.text

            delegate?.callLogIn(email: email!, password: password!)
            
        }else{
            
         //   sender.isHidden = false
        }
        
    }
    func pressRegisterOn(sender:UIButton){
        delegate?.goToRegister()
    }
    func pressForgetOn(sender:UIButton){
        delegate?.goToForget()
    }
}
