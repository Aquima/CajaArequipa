//
//  ProfileViewController.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 3/23/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit

class ProfileViewController: BoxViewController {

    var topBar:TopBar!
    var meProfileInfo:MeProfileInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    func createView(){
        
        view.backgroundColor = UIColor.white
        topBar = TopBar()
        topBar.drawBody(leftImage: #imageLiteral(resourceName: "follows"), rightImage: #imageLiteral(resourceName: "settings"), title: "Raúl Quispe")
        view.addSubview(topBar)
        
        meProfileInfo = MeProfileInfo()
        meProfileInfo.drawBody()
        view.addSubview(meProfileInfo)
        
    }

}
