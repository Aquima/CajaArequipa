//
//  ChangePasswordViewController.swift
//  cajaarequipa
//
//  Created by Nara on 7/27/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit

class ChangePasswordViewController: BoxViewController,TopBarDelegate {
    var topBar: TopBar!
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
        // Do any additional setup after loading the view.
    }
    // MARK: - UIView
    func createView(){
        topBar = TopBar()
        topBar.delegate = self
        topBar.drawBody(leftImage: #imageLiteral(resourceName: "back"), rightImage: #imageLiteral(resourceName: "hide"), title: "Cambiar Contraseña")
        view.addSubview(topBar)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func pressLeft(sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    func pressRight(sender:UIButton){
        
    }
}
