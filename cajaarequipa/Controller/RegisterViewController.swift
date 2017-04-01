//
//  RegisterViewController.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 3/20/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit
import Firebase
protocol RegisterViewControllerDelegate {
    func completedRegister()
}
class RegisterViewController: UIViewController, RegisterFormDelegate {

    var delegate:RegisterViewControllerDelegate?
    
    var form: RegisterForm!
    var top: TopView!
    
    let screenSize: CGRect = UIScreen.main.bounds
    let valuePro:CGFloat  = CGFloat(NSNumber.getPropotionalValueDevice())
    
    let currentUser:EntityUser = EntityUser()
    var currentDocument: String!
    var currentName: String!
    var currentLocality: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    // MARK: - UIView
    func createView(){
        
        top = TopView()
        form = RegisterForm()
        
        top.drawBody()
        top.frame = CGRect(x: 0, y: 0*valuePro, width: screenSize.size.width, height: 147*valuePro)
        
        form.drawBody()
        form.frame = CGRect(x: 0, y: 147*valuePro, width: screenSize.size.width, height: 421*valuePro)
        
        top.updateView()
        form.updateView()
        
        view.addSubview(top)
        view.addSubview(form)
        
        let tapTop = UITapGestureRecognizer(target: self, action:#selector(handleTap(sender:)))
        let tapForm = UITapGestureRecognizer(target: self, action:#selector(handleTap(sender:)))
        top.addGestureRecognizer(tapTop)
        form.addGestureRecognizer(tapForm)

        form.delegate = self
        
    }
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        // handling code
        form.resignFirstResponderList()
    }
    func goToBack(sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - RegisterFormDelegate
    func callValidate(document:String){
        getDocumentStatus(document: document)
    }
    func callRegister(email:String,password:String,document:String,error:errorRegisterType){
     //   form.resignFirstResponderList()
        //call to firebase
        if form.isPrepareForRegistrate == false {
           showError(error: error)
        }else{
 
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
                
                //   self.activityIndicatorView.stopAnimating()
                // self.btnRegis.isHidden = false
                if error == nil {


                    //cuando creo delegar succes completed y  crear email y password al currentUser
                    let post:[String:Any] = ["email": email ,
                                             "name": self.currentName,
                                             "locality": self.currentLocality,
                                             "document": document,
                                             "pictureurl":"",
                                             "followers":0,
                                             "follows":0,
                                             "website":"",
                                             "description":""
                                             ]
                    
                    var ref: FIRDatabaseReference!
                  //  FIRAuth.auth()?.currentUser?.uid ?? String()
                    ref = FIRDatabase.database().reference()
                  //  ref.child("users/\(email.getIDFromFireBase())").updateChildValues(post)
                    ref.child("users/\(user?.uid ?? String())").updateChildValues(post)
                    self.delegate?.completedRegister()

                }else{
                    if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                        
                        switch errCode {
                        case .errorCodeInvalidEmail:
                            self.showError(error: .errorRegisterExistMail)
                        case .errorCodeNetworkError:
                            self.showError(error: .errorRegisterNoNetwork)
                        default:
                            print("Other error!")
                            
                        }
                        
                    }
                }
            })
        }
    }
    func showError(error: errorRegisterType) {
        
        var message:String?
        let alertError = UIAlertController()
        
        if error == errorRegisterType.errorRegisterDocument {
            message = "Tu documento no se encuentra en nuestra lista de clientes y/o colaboradores. por favor contactanos. \ncentral telefonica:(51)(54) 380670 "
            alertError.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: {
                (result : UIAlertAction) -> Void in
                self.form.stopAnimation()
                
            }))
            alertError.addAction(UIAlertAction(title: "Contactar", style: UIAlertActionStyle.default, handler: {
                (result : UIAlertAction) -> Void in
                self.form.stopAnimation()
                let phoneStr:String = "5154380670"
                if let url = URL(string: "tel://\(phoneStr)") {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        // Fallback on earlier versions
                    }
                }
                
            }))
        }else if error == errorRegisterType.errorRegisterDocumentRegistrated {
             message = "Tu documento ya se encuentra registrado."
            alertError.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: {
                (result : UIAlertAction) -> Void in
                self.form.stopAnimation()
                
            }))

        }else if error == errorRegisterType.errorRegisterMail {
            message = "El formato del correo electronico ingresado no es correcto."
            alertError.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: {
                (result : UIAlertAction) -> Void in
                self.form.stopAnimation()
                
            }))
        }else if error == errorRegisterType.errorRegisterPassword{
            message = "Sus contraseñas no coinciden."
            alertError.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: {
                (result : UIAlertAction) -> Void in
                self.form.stopAnimation()
                
            }))
        }else if error == errorRegisterType.errorRegisterDigit{
            message = "Ingrese el noveno digito de su DNI XXXXXXXX - D"
            alertError.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: {
                (result : UIAlertAction) -> Void in
                self.form.stopAnimation()
                
            }))
        }else if error == errorRegisterType.errorRegisterExistMail{
            message = "El correo electronico ingresado ya se encuentra registrado."
            alertError.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: {
                (result : UIAlertAction) -> Void in
                self.form.stopAnimation()
                
            }))
        }else if error == errorRegisterType.errorRegisterNoNetwork{
            message = "Problemas de conexion por favor intentelo mas tarde."
            alertError.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: {
                (result : UIAlertAction) -> Void in
                self.form.stopAnimation()
                
            }))
        }
        
        alertError.message = message
        alertError.title = "Caja Arequipa"
     ///   alertError.preferredStyle = UIAlertControllerStyle.alert
        self.present(alertError, animated: true, completion: {
            
        })
        
    }
    func goToBack(){
   //     form.resignFirstResponderList()
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - ApiConsume
    func getDocumentStatus(document:String){

        let ref = FIRDatabase.database().reference().child("users").queryOrdered(byChild: "document").queryEqual(toValue : document)
        
        ref.observe(.value, with:{ (snapshot: FIRDataSnapshot) in

            if snapshot.hasChildren() == true {
                //show error
                self.form.currentError = .errorRegisterDocumentRegistrated
                self.form.isDocumentValid = false
            }else{
                let notificationName = Notification.Name("endDocumentStatus")
                NotificationCenter.default.addObserver(self, selector: #selector(self.endDocumentStatus), name: notificationName, object: nil)
                
                let params:Dictionary <String,String> = Dictionary()
                
                var headers:Dictionary <String,String> = Dictionary()
                headers["Content-Type"] = "application/json"
                
                ApiConsume.sharedInstance.consumeDataWithNewSession(url: "buscarPersona/\(document)", path: Constants.API_URL, headers: headers, params: params, typeParams: TypeParam.noParams, httpMethod: HTTP_METHOD.GET, notificationName: "endDocumentStatus")

            }
        }) { (error) in
            print(error.localizedDescription)
        }

        
    }
    
    func endDocumentStatus(notification:Notification){
        NotificationCenter.default.removeObserver(self, name: notification.name, object: nil)
        DispatchQueue.main.async(execute: {
            if let dictionary = notification.object as? [String: Any] {
                // validate token != nil
                if dictionary["buscarPersonaResult"] != nil {
                    
                    self.form.currentError = .errorRegisterDocument
        
                    let objectPerson:NSDictionary = dictionary["buscarPersonaResult"] as! NSDictionary
                    
                    if (objectPerson.object(forKey: "Status") as! String) == "1" {
                        //go create user
                         if let person = objectPerson.object(forKey: "Persona") as? [String: Any] {
                            self.currentName = person["NombreCompleto"] as? String
                            self.currentLocality = person["Localidad"] as? String
                        }
                        self.form.isDocumentValid = true
                    }else{
                        self.form.isDocumentValid = false
                        self.form.currentError = .errorRegisterDocument
                        // show error this document state: in use
                    }
    
                }else{
                    self.showError(error: .errorRegisterNoNetwork)
                }
                
            }
            
        })
    }
    
  
}
