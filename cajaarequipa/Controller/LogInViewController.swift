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
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            
            if error != nil {
                if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                    
                    switch errCode {
                    case .errorCodeInvalidEmail:
                        print("invalid email")
                        
                    case .errorCodeWrongPassword:
                        print("invalid password")
                        
                        //                    case .error:
                        //                        print("invalid password")
                    //
                    case .errorCodeNetworkError:
                        print("No Hay internet")
                    default:
                        print("Other error!")
                        
                    }
                    
                }
            }else{
                print("signIn successful")
                self.form.btnEnter.isHidden = false
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
}
