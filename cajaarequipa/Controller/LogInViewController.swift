//
//  LogInViewController.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 3/20/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController,LogInFormDelegate,RegisterViewControllerDelegate {

    var form: LogInForm!
    var top: TopView!
    let screenSize: CGRect = UIScreen.main.bounds
    let valuePro:CGFloat  = CGFloat(NSNumber.getPropotionalValueDevice())
    
    var registerVC:RegisterViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createView()
      //printFonts()
    }
    func printFonts() {
        let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNames(forFamilyName: familyName )
            print("Font Names = [\(names)]")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
      
    }
    // MARK: - LogInFormDelegate
    func callLogIn(email:String,password:String){
        //call firebase rca@g.com 123456
        if Int(email) != nil {
            //is document
            getMail(document: email,password:password)
        }else{
            authWithMail(email: email, password: password)
        }
    }
    func getMail(document:String,password:String){

        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()//.queryLimited(toFirst:5)
        ref.child("users").queryOrdered(byChild: "document").queryEqual(toValue: document).observeSingleEvent(of: .value, with:  { (snapshot) -> Void in

            if (snapshot.value is NSNull) {
                print("getMail")
                // show error dni invalido
                self.showError(error: .errorLogInMail)
                self.form.btnEnter.isHidden = false
                ref.removeAllObservers()
            } else {

                for child in snapshot.children {
                    let data:FIRDataSnapshot = child as! FIRDataSnapshot
                    let snapDictionary:Dictionary = data.value! as! Dictionary<String, Any>
                    let tempUser:User = User()
                    tempUser.translateToModel(data: snapDictionary)
                    self.authWithMail(email: tempUser.email, password: password)
                }

                ref.removeAllObservers()
            }
            
        })
    }
    func authWithMail(email:String,password:String){
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            
            if error != nil {
                if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                    
                    switch errCode {  
                    case .errorCodeWrongPassword:
                        self.showError(error: .errorLogInPassword)
                    case .errorCodeInvalidEmail:
                        self.showError(error: .errorLogInMail)
                    case .errorCodeNetworkError:
                        self.showError(error: .errorLogInNetwork)
                    default:
                        self.form.stopAnimation()
                        self.form.btnEnter.isHidden = false
                    }
                    
                }
            }else{

                self.form.btnEnter.isHidden = false
                self.updateCheckFollowing(uid: (user?.uid)!)
                DispatchQueue.main.async(execute: {
                    _ = self.navigationController?.popToRootViewController(animated: true)
                })
            }
        })

    }
    func goToRegister(){
        registerVC = RegisterViewController()
        registerVC.delegate = self
        self.present(registerVC, animated: true, completion: nil)
    }
    func goToForget() {
        
    }
    // MARK: - UIView
    func createView(){
        
        top = TopView()
        form = LogInForm()
        
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
    // MARK: - RegisterViewControllerDelegate
    func completedRegister() {
        registerVC.dismiss(animated: true, completion: {
            DispatchQueue.main.async(execute: {
                _ = self.navigationController?.popToRootViewController(animated: true)
            })
        })
      
       // self.navigationController.
    }
    func showError(error: errorLogInType) {
        
        var message:String?
        let alertError = UIAlertController(title: "Caja Arequipa", message: nil, preferredStyle: .alert)
        
       if error == errorLogInType.errorLogInPassword {
            message = "La contraseña ingresada no es correcta."
            alertError.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: {
                (result : UIAlertAction) -> Void in
                self.form.stopAnimation()
                
            }))
            
        }else if error == errorLogInType.errorLogInMail {
            message = "El correo electronico o DNI ingresado no esta registrado."
            alertError.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: {
                (result : UIAlertAction) -> Void in
                self.form.stopAnimation()
                
            }))
        }else if error == errorLogInType.errorLogInNetwork{
        message = "Problemas de conexion por favor intentelo mas tarde."
            alertError.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: {
                (result : UIAlertAction) -> Void in
                self.form.stopAnimation()
                
            }))
       }else if error == errorLogInType.none{
        message = "Intentelo mas tarde."
        alertError.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: {
            (result : UIAlertAction) -> Void in
                self.form.stopAnimation()
            
        }))
        }
        
        alertError.message = message
      //  alertError.title = "Caja Arequipa"
        self.present(alertError, animated: true, completion: {
              //  self.form.stopAnimation()
        })
        
    }

    func updateCheckFollowing( uid:String) {
        
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        
        let post:[String:Any] = [uid:true]
        
        ref.child("following").child(uid).updateChildValues(post)
        
        let postFollowers:[String:Any] = [uid:true]
        ref.child("followers").child(uid).updateChildValues(postFollowers)
        
        ref.removeAllObservers()
        
    }
    

}
