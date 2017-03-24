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
    func callRegister(email:String,password:String,document:String){
     //   form.resignFirstResponderList()
        //call to firebase
    }
    func goToBack(){
   //     form.resignFirstResponderList()
        self.dismiss(animated: true, completion: nil)
    }
}
