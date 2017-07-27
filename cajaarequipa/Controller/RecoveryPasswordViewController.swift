//
//  RecoveryPasswordViewController.swift
//  cajaarequipa
//
//  Created by Nara on 7/27/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit

class RecoveryPasswordViewController: BoxViewController,TopBarDelegate {
    var topBar: TopBar!
    var recoveryView: RecoveryView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
        // Do any additional setup after loading the view.
    }
    // MARK: - UIView
    func createView(){
        topBar = TopBar()
        topBar.delegate = self
        topBar.drawBody(leftImage: #imageLiteral(resourceName: "back"), rightImage: #imageLiteral(resourceName: "hide"), title: "Recuperar Contraseña")
        view.addSubview(topBar)
        
        recoveryView = RecoveryView()
        recoveryView.frame = CGRect(x: 0, y: 78*valuePro, width: screenSize.size.width, height: 421*valuePro)
        recoveryView.drawBody()
        
        recoveryView.updateView()
        view.addSubview(recoveryView)
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
