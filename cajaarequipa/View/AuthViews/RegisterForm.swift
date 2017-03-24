//
//  RegisterForm.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 3/22/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

enum inputRegisterType{

    case keyRegisterDocument
    case keyRegisterDigit
    case keyRegisterMail
    case keyRegisterPassword
    case keyRegisterRePassword
    
}
protocol RegisterFormDelegate {
    func callRegister(email:String,password:String,document:String)
    func goToBack()

}
class RegisterForm: UIView {

    
    var delegate:RegisterFormDelegate?
    
    let screenSize: CGRect = UIScreen.main.bounds
    let valuePro:CGFloat  = CGFloat(NSNumber.getPropotionalValueDevice())
    
    var lblTitleLabel: UILabel!
    
    var txtDocument: UITextField!
    var txtDigit: UITextField!
    var txtEmail: UITextField!
    var txtPassword: UITextField!
    var txtRePassword: UITextField!

    var btnRegister: UIButton!
    var btnCancel: UIButton!
    
    var lineDocument: UIView!
    var lineDigit: UIView!
    var lineEmail: UIView!
    var linePassword: UIView!
    var lineRePassword: UIView!
    
    var inputList:[UITextField] = []
    
    var activityIndicatorView: NVActivityIndicatorView!
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    func drawBody(){
        
        self.backgroundColor = UIColor.white
        //Drawing code
        lblTitleLabel = UILabel()
        lblTitleLabel.titleColor(color: "002753",text:"REGISTRARSE")
        
        txtDocument = UITextField()
        txtDocument.styleForm()
        txtDocument.placeholder = "Numero de DNI"
        
        txtDigit = UITextField()
        txtDigit.styleForm()
        txtDigit.placeholder = "Digito Verificador"

        txtEmail = UITextField()
        txtEmail.styleForm()
        txtEmail.placeholder = "Correo Electrónico"
        
        txtPassword = UITextField()
        txtPassword.styleForm()
        txtPassword.placeholder = "Contraseña"
        
        txtRePassword = UITextField()
        txtRePassword.styleForm()
        txtRePassword.placeholder = "Repetir Contraseña"
        
        btnRegister = UIButton()
        btnCancel = UIButton()
        
        lineDocument = UIView()
        lineDocument.backgroundColor = UIColor.init(hexString: "cccccc")
        
        lineDigit = UIView()
        lineDigit.backgroundColor = UIColor.init(hexString: "cccccc")
        
        lineEmail = UIView()
        lineEmail.backgroundColor = UIColor.init(hexString: "cccccc")
        
        linePassword = UIView()
        linePassword.backgroundColor = UIColor.init(hexString: "cccccc")
        
        lineRePassword = UIView()
        lineRePassword.backgroundColor = UIColor.init(hexString: "cccccc")
        
        btnRegister.fillTextColor(color: "002753",text: "Registrar")
        btnCancel.borderTextColor(color: "f27065", text: "Cancelar")
       
        let frame =  CGRect(x: btnRegister.frame.origin.x + (btnRegister.frame.size.width-35*valuePro)/2, y:  btnRegister.frame.origin.y + (btnRegister.frame.size.height-35*valuePro)/2, width:35*valuePro, height: 35*valuePro)

        activityIndicatorView = NVActivityIndicatorView(frame: frame,
                                                        type: NVActivityIndicatorType(rawValue:1)!)
        activityIndicatorView.color = UIColor.init(hexString: "002753")
        activityIndicatorView.stopAnimating()
        
        addSubview(activityIndicatorView)
        addSubview(lblTitleLabel)
        
        addSubview(txtDocument)
        addSubview(txtDigit)
        addSubview(txtEmail)
        addSubview(txtPassword)
        addSubview(txtRePassword)
        
        addSubview(btnRegister)
        addSubview(btnCancel)
        
        addSubview(lineDocument)
        addSubview(lineDigit)
        addSubview(lineEmail)
        addSubview(linePassword)
        addSubview(lineRePassword)
        
    }
    func updateView(){

        lblTitleLabel.frame = CGRect(x: (screenSize.width-258*valuePro)/2, y: 10*valuePro, width: 258*valuePro, height: 17*valuePro)
        lblTitleLabel.font = UIFont (name: "HelveticaRounded-Bold", size: 13*valuePro)
        //--
        txtDocument.frame = CGRect(x: ((screenSize.width-1*valuePro)/2)-111*valuePro, y: 44*valuePro+0*(44*valuePro), width: 101*valuePro, height: 44*valuePro)
        txtDocument.font = UIFont (name: "MyriadPro-Regular", size: 13*valuePro)
        txtDocument.textAlignment = .center
        lineDocument.frame = CGRect(x: (screenSize.width-258*valuePro)/2, y: 88*valuePro+0*(44*valuePro), width: 258*valuePro, height: 0.8*valuePro)
        //--
        txtDigit.frame = CGRect(x:((screenSize.width-1*valuePro)/2)+5*valuePro, y: 44*valuePro+0*(44*valuePro), width: 124*valuePro, height: 44*valuePro)
        txtDigit.font = UIFont (name: "MyriadPro-Regular", size: 13*valuePro)
        txtDigit.textAlignment = .center
        
        lineDigit.frame = CGRect(x: (screenSize.width-1*valuePro)/2, y: 44*valuePro+0*(44*valuePro), width: 1*valuePro, height: 34*valuePro)
        //--
        txtEmail.frame = CGRect(x: (screenSize.width-212*valuePro)/2, y: 44*valuePro+1*(44*valuePro), width: 212*valuePro, height: 44*valuePro)
        txtEmail.font = UIFont (name: "MyriadPro-Regular", size: 13*valuePro)
        
        lineEmail.frame = CGRect(x: (screenSize.width-258*valuePro)/2, y: 88*valuePro+1*(44*valuePro), width: 258*valuePro, height: 0.8*valuePro)
        //--
        txtPassword.frame = CGRect(x: (screenSize.width-212*valuePro)/2, y: 44*valuePro+2*(44*valuePro), width: 212*valuePro, height: 44*valuePro)
        txtPassword.font = UIFont (name: "MyriadPro-Regular", size: 13*valuePro)
        txtPassword.isSecureTextEntry = true
        
        linePassword.frame = CGRect(x: (screenSize.width-258*valuePro)/2, y:  88*valuePro+2*(44*valuePro), width: 258*valuePro, height: 0.8*valuePro)
        //--
        txtRePassword.frame = CGRect(x: (screenSize.width-212*valuePro)/2, y: 44*valuePro+3*(44*valuePro), width: 212*valuePro, height: 44*valuePro)
        txtRePassword.font = UIFont (name: "MyriadPro-Regular", size: 13*valuePro)
        txtRePassword.isSecureTextEntry = true
        
        lineRePassword.frame = CGRect(x: (screenSize.width-258*valuePro)/2, y:  88*valuePro+3*(44*valuePro), width: 258*valuePro, height: 0.8*valuePro)
        //--
        btnRegister.frame = CGRect(x: (screenSize.width-258*valuePro)/2, y: 44*valuePro+5.6*(44*valuePro), width: 258*valuePro, height: 44*valuePro)
        btnRegister.layer.cornerRadius = 22*valuePro
        btnRegister.titleLabel?.font = UIFont (name: "HelveticaRounded-Bold", size: 14*valuePro)
        
        btnCancel.frame = CGRect(x: (screenSize.width-258*valuePro)/2, y: 44*valuePro+6.8*(44*valuePro), width: 258*valuePro, height: 44*valuePro)
        btnCancel.layer.cornerRadius = 22*valuePro
        btnCancel.titleLabel?.font = UIFont (name: "HelveticaRounded-Bold", size: 14*valuePro)
        
        inputList.append(txtDocument)
        inputList.append(txtDigit)
        inputList.append(txtEmail)
        inputList.append(txtPassword)
        inputList.append(txtRePassword)
        
        //add Actions
        btnRegister.addTarget(self, action: #selector(registerManualValidate(sender:)), for: .touchUpInside)
        btnCancel.addTarget(self, action: #selector(pressCancelOn(sender:)), for: .touchUpInside)

    }
    // MARK: - UITextField
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        switch textField.tag {
        case inputRegisterType.keyRegisterDocument.hashValue:
            
            break
        case inputRegisterType.keyRegisterDigit.hashValue:
            
            break
        case inputRegisterType.keyRegisterMail.hashValue:
            
            break
        case inputRegisterType.keyRegisterPassword.hashValue:
            
            break
        case inputRegisterType.keyRegisterRePassword.hashValue:
            
            break
        default:
            return true
        }
        return true
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         var inputText:UITextField!
        switch textField.tag {
        case inputRegisterType.keyRegisterDocument.hashValue:
            
            inputText = self.inputList[ inputRegisterType.keyRegisterDigit.hashValue]
            inputText.becomeFirstResponder()
            break
        case inputRegisterType.keyRegisterDigit.hashValue:
            
            inputText = self.inputList[ inputRegisterType.keyRegisterMail.hashValue]
            textField.resignFirstResponder()
            break
        case inputRegisterType.keyRegisterMail.hashValue:
            
            inputText = self.inputList[ inputRegisterType.keyRegisterPassword.hashValue]
            textField.resignFirstResponder()
            break
        case inputRegisterType.keyRegisterPassword.hashValue:
            
            inputText = self.inputList[ inputRegisterType.keyRegisterRePassword.hashValue]
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
    func registerManualValidate(sender:UIButton)  {
        sender.isHidden = true
        let frame =  CGRect(x: sender.frame.origin.x + (sender.frame.size.width-35*valuePro)/2, y:  sender.frame.origin.y + (sender.frame.size.height-35*valuePro)/2, width:35*valuePro, height: 35*valuePro)
        activityIndicatorView.frame = frame
        //validate all fields
        activityIndicatorView.startAnimating()
        let document:String = self.inputList[inputRegisterType.keyRegisterDocument.hashValue].text!
        let email:String = self.inputList[inputRegisterType.keyRegisterMail.hashValue].text!
        let password:String = self.inputList[inputRegisterType.keyRegisterPassword.hashValue].text!
        
        if document != "" && email != "" && password != "" {
            
            delegate?.callRegister(email: email, password: password, document: document)
            
        }else{
            
           // sender.isHidden = false
            
        }
        
    }
    func pressCancelOn(sender:UIButton){
        delegate?.goToBack()
    }
}
