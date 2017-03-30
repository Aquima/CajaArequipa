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
enum errorRegisterType{
    
    case errorRegisterDocument
    case errorRegisterDigit
    case errorRegisterMail
    case errorRegisterPassword
    case errorRegisterDocumentRegistrated
    case errorRegisterExistMail
    case errorRegisterIncorrectPassword
    case errorRegisterNoNetwork
    case none
    
}
protocol RegisterFormDelegate {
    
    func callValidate(document:String)
    func callRegister(email:String,password:String,document:String, error:errorRegisterType)
    func goToBack()

}
class RegisterForm: UIView {
    
    var delegate:RegisterFormDelegate?
    var isPrepareForRegistrate:Bool = false
    var isDocumentValid:Bool = false
  
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
    var valueVerified:String!
    
    var currentError:errorRegisterType = errorRegisterType.none
    
    var activityIndicatorView: NVActivityIndicatorView!
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    func drawBody(){
        
        self.backgroundColor = UIColor.white
        //Drawing code
        lblTitleLabel = UILabel()
        lblTitleLabel.titleColor(color: GlobalConstants.color.blue,text:"REGISTRARSE")
        
        txtDocument = UITextField()
        txtDocument.styleForm()
        txtDocument.placeholder = "Numero de DNI"
        txtDocument.textAlignment = .center
        txtDocument.keyboardType = .numberPad
        txtDocument.clearButtonMode = .always
        
        txtDigit = UITextField()
        txtDigit.styleForm()
        txtDigit.placeholder = "Digito Verificador"
        txtDigit.textAlignment = .center
        txtDigit.keyboardType = .numberPad
        txtDigit.clearButtonMode = .always
        
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
        lineDocument.backgroundColor = UIColor.init(hexString: GlobalConstants.color.linColor)
        
        lineDigit = UIView()
        lineDigit.backgroundColor = UIColor.init(hexString: GlobalConstants.color.linColor)
        
        lineEmail = UIView()
        lineEmail.backgroundColor = UIColor.init(hexString: GlobalConstants.color.linColor)
        
        linePassword = UIView()
        linePassword.backgroundColor = UIColor.init(hexString: GlobalConstants.color.linColor)
        
        lineRePassword = UIView()
        lineRePassword.backgroundColor = UIColor.init(hexString: GlobalConstants.color.linColor)
        
        btnRegister.fillTextColor(color:  GlobalConstants.color.blue,text: "Registrar")
        btnCancel.borderTextColor(color:  GlobalConstants.color.cancelRed , text: "Cancelar")
       
        let frame =  CGRect(x: btnRegister.frame.origin.x + (btnRegister.frame.size.width-35*valuePro)/2, y:  btnRegister.frame.origin.y + (btnRegister.frame.size.height-35*valuePro)/2, width:35*valuePro, height: 35*valuePro)

        activityIndicatorView = NVActivityIndicatorView(frame: frame,
                                                        type: NVActivityIndicatorType(rawValue:1)!)
        activityIndicatorView.color = UIColor.init(hexString: GlobalConstants.color.blue)
        activityIndicatorView.stopAnimating()
        
        addSubview(activityIndicatorView)
        addSubview(lblTitleLabel)
        
        addSubview(txtDocument)
     //   addSubview(txtDigit)
        addSubview(txtEmail)
        addSubview(txtPassword)
        addSubview(txtRePassword)
        
        inputList.append(txtEmail)
        inputList.append(txtPassword)
        inputList.append(txtRePassword)
        
        addSubview(btnRegister)
        addSubview(btnCancel)
        
        addSubview(lineDocument)
      //  addSubview(lineDigit)
        addSubview(lineEmail)
        addSubview(linePassword)
        addSubview(lineRePassword)
        
        //add Actions
        txtDocument.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        btnRegister.addTarget(self, action: #selector(registerManualValidate(sender:)), for: .touchUpInside)
        btnCancel.addTarget(self, action: #selector(pressCancelOn(sender:)), for: .touchUpInside)
  
    }
    func updateView(){

        lblTitleLabel.frame = CGRect(x: (screenSize.width-258*valuePro)/2, y: 10*valuePro, width: 258*valuePro, height: 17*valuePro)
        lblTitleLabel.font = UIFont (name: GlobalConstants.font.helveticaRoundedBold, size: 13*valuePro)
        //--
        txtDocument.frame = CGRect(x: ((screenSize.width-1*valuePro)/2)-111*valuePro, y: 44*valuePro+0*(44*valuePro), width: 101*valuePro, height: 44*valuePro)
        txtDocument.font = UIFont (name: GlobalConstants.font.myriadProRegular, size: 13*valuePro)

        lineDocument.frame = CGRect(x: (screenSize.width-258*valuePro)/2, y: 88*valuePro+0*(44*valuePro), width: 258*valuePro, height: 0.8*valuePro)
        //--
        txtDigit.frame = CGRect(x:((screenSize.width-1*valuePro)/2)+5*valuePro, y: 44*valuePro+0*(44*valuePro), width: 124*valuePro, height: 44*valuePro)
        txtDigit.font = UIFont (name: GlobalConstants.font.myriadProRegular, size: 13*valuePro)
 
        lineDigit.frame = CGRect(x: (screenSize.width-1*valuePro)/2, y: 44*valuePro+0*(44*valuePro), width: 1*valuePro, height: 34*valuePro)
        //--
        txtEmail.frame = CGRect(x: (screenSize.width-212*valuePro)/2, y: 44*valuePro+1*(44*valuePro), width: 212*valuePro, height: 44*valuePro)
        txtEmail.font = UIFont (name: GlobalConstants.font.myriadProRegular, size: 13*valuePro)
        
        lineEmail.frame = CGRect(x: (screenSize.width-258*valuePro)/2, y: 88*valuePro+1*(44*valuePro), width: 258*valuePro, height: 0.8*valuePro)
        //--
        txtPassword.frame = CGRect(x: (screenSize.width-212*valuePro)/2, y: 44*valuePro+2*(44*valuePro), width: 212*valuePro, height: 44*valuePro)
        txtPassword.font = UIFont (name: GlobalConstants.font.myriadProRegular, size: 13*valuePro)
        txtPassword.isSecureTextEntry = true
        
        linePassword.frame = CGRect(x: (screenSize.width-258*valuePro)/2, y:  88*valuePro+2*(44*valuePro), width: 258*valuePro, height: 0.8*valuePro)
        //--
        txtRePassword.frame = CGRect(x: (screenSize.width-212*valuePro)/2, y: 44*valuePro+3*(44*valuePro), width: 212*valuePro, height: 44*valuePro)
        txtRePassword.font = UIFont (name: GlobalConstants.font.myriadProRegular, size: 13*valuePro)
        txtRePassword.isSecureTextEntry = true
        
        lineRePassword.frame = CGRect(x: (screenSize.width-258*valuePro)/2, y:  88*valuePro+3*(44*valuePro), width: 258*valuePro, height: 0.8*valuePro)
        //--
        btnRegister.frame = CGRect(x: (screenSize.width-258*valuePro)/2, y: 44*valuePro+5.6*(44*valuePro), width: 258*valuePro, height: 44*valuePro)
        btnRegister.layer.cornerRadius = 22*valuePro
        btnRegister.titleLabel?.font = UIFont (name: GlobalConstants.font.helveticaRoundedBold, size: 14*valuePro)
        
        btnCancel.frame = CGRect(x: (screenSize.width-258*valuePro)/2, y: 44*valuePro+6.8*(44*valuePro), width: 258*valuePro, height: 44*valuePro)
        btnCancel.layer.cornerRadius = 22*valuePro
        btnCancel.titleLabel?.font = UIFont (name: GlobalConstants.font.helveticaRoundedBold, size: 14*valuePro)
        
        inputList.append(txtDocument)
        inputList.append(txtDigit)
        inputList.append(txtEmail)
        inputList.append(txtPassword)
        inputList.append(txtRePassword)
 
    }
    // MARK: - UITextField
    func textFieldDidChange(textField: UITextField) {
        //your code
        if textField.text?.characters.count == 8 {
            self.delegate?.callValidate(document: textField.text!)
            self.inputList[ inputRegisterType.keyRegisterMail.hashValue].becomeFirstResponder()
            valueVerified = validate(document: textField.text!)
            print(valueVerified)
        }
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         var inputText:UITextField!
        switch textField.tag {
        case inputRegisterType.keyRegisterDocument.hashValue:

            inputText = self.inputList[ inputRegisterType.keyRegisterMail.hashValue]
            inputText.becomeFirstResponder()
            break
//        case inputRegisterType.keyRegisterDigit.hashValue:
//            
//            inputText = self.inputList[ inputRegisterType.keyRegisterMail.hashValue]
//            textField.becomeFirstResponder()
//            break
        case inputRegisterType.keyRegisterMail.hashValue:
            
            inputText = self.inputList[ inputRegisterType.keyRegisterPassword.hashValue]
            textField.becomeFirstResponder()
            break
        case inputRegisterType.keyRegisterPassword.hashValue:
            
            inputText = self.inputList[ inputRegisterType.keyRegisterRePassword.hashValue]
            textField.becomeFirstResponder()
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
        let rePassword:String = self.inputList[inputRegisterType.keyRegisterRePassword.hashValue].text!
        if isDocumentValid == false{
         //   currentError = errorRegisterType.errorRegisterDocument
            isPrepareForRegistrate = false
        }else if email.isValidEmail() == false {
            currentError = errorRegisterType.errorRegisterMail
            isPrepareForRegistrate = false
        }else if password != rePassword {
            // mostrar error en password
            currentError = errorRegisterType.errorRegisterPassword
            isPrepareForRegistrate = false
        }else  {
            isPrepareForRegistrate = true
            currentError = errorRegisterType.none
        }
        
        delegate?.callRegister(email: email.lowercased(), password: password, document: document, error: currentError)
    
    }
    func pressCancelOn(sender:UIButton){
        delegate?.goToBack()
    }
    func validate(document:String) -> String{
        
        let characters = document.characters.map { String($0) }
        
        let multA = Int(characters[0])!*7
        let multB = Int(characters[1])!*3
        let multC = Int(characters[2])!*1
        let multD = Int(characters[3])!*7
        let multE = Int(characters[4])!*3
        let multF = Int(characters[5])!*1
        let multG = Int(characters[6])!*7
        let multH = Int(characters[7])!*3
        
        let suma = multA+multB+multC+multD+multE+multF+multG+multH
        
        let convert = String(suma)
        
       return String(describing: convert.characters.last)
        
    }
    func stopAnimation(){
        activityIndicatorView.stopAnimating()
        btnRegister.isHidden = false
    }
}
