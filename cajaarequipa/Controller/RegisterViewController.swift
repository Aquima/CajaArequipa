//
//  RegisterViewController.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 3/20/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, RegisterFormDelegate {

    var form: RegisterForm!
    var top: TopView!
    let screenSize: CGRect = UIScreen.main.bounds
    let valuePro:CGFloat  = CGFloat(NSNumber.getPropotionalValueDevice())
    
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
    func callRegister(email:String,password:String,document:String){
     //   form.resignFirstResponderList()
        //call to firebase
        
    }
    func goToBack(){
   //     form.resignFirstResponderList()
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - ApiConsume
    func getDocumentStatus(document:String){
        
        let notificationName = Notification.Name("endDocumentStatus")
        NotificationCenter.default.addObserver(self, selector: #selector(self.endDocumentStatus), name: notificationName, object: nil)
        
        let params:Dictionary <String,String> = Dictionary()

        var headers:Dictionary <String,String> = Dictionary()
        headers["Content-Type"] = "application/json"
        
        ApiConsume.sharedInstance.consumeDataWithNewSession(url: "buscarPersona/\(document)", path: Constants.API_URL, headers: headers, params: params, typeParams: TypeParam.noParams, httpMethod: HTTP_METHOD.GET, notificationName: "endDocumentStatus")
        
    }
    
    func endDocumentStatus(notification:Notification){
        NotificationCenter.default.removeObserver(self, name: notification.name, object: nil)
        DispatchQueue.main.async(execute: {
            if let dictionary = notification.object as? [String: Any] {
                // validate token != nil
                if dictionary["buscarPersonaResult"] != nil {
                    
                    let objectPerson:NSDictionary = dictionary["buscarPersonaResult"] as! NSDictionary
                    
                    if (objectPerson.object(forKey: "Status") as! String) == "1" {
                        //go create user
                        self.form.isPrepareForRegistrate = true
                    }else{
                        self.form.isPrepareForRegistrate = false
                        // show error this document state: in use
                        let alert = UIAlertController(title: "Caja Arequipa", message: "Tu documento no se encuentra en nuestra lista de clientes y/o colaboradores. por favor contactanos. \ncentral telefonica:(51)(54) 380670 ", preferredStyle: UIAlertControllerStyle.alert)
                        
                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: {
                            (result : UIAlertAction) -> Void in
                            
                            
                        }))
                        alert.addAction(UIAlertAction(title: "Contactar", style: UIAlertActionStyle.default, handler: {
                            (result : UIAlertAction) -> Void in
                            
                            if let url = URL(string: "tel://\(5154380670)") {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                            
                        }))
                        self.present(alert, animated: true, completion: {
                            
                        })
                    }
                    
                    
                }else{
                    let alert = UIAlertController(title: "Caja Arequipa", message: "Tu documento no se encuentra en nuestra base lista de clientes. por favor contactanos. \ncentral telefonica:(51)(54) 380670 ", preferredStyle: UIAlertControllerStyle.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: {
                        (result : UIAlertAction) -> Void in
                        

                    }))
 
                    // show the alert
                    self.present(alert, animated: true, completion: {
                        
                    })
                }
                
            }
            
        })
    }
}
