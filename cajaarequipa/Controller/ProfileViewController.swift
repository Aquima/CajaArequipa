//
//  ProfileViewController.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 3/23/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: BoxViewController,TopBarDelegate {

    var topBar:TopBar!
    var meProfileInfo:MeProfileInfo!
    var publications:Publications!
    var currentUser:User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser = User()
        // Do any additional setup after loading the view.
        createView()
        updateValues()
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        ref.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).observe(.childChanged, with:  { (snapshot) -> Void in
            self.updateValues()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
       
    }
    func updateValues(){
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        ref.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.currentUser.translateToModel(data: value! )
            self.meProfileInfo.updateView(user:self.currentUser)
            self.topBar.lblTitle.text = self.currentUser.name
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    // MARK: - Navigation
    func createView(){
        
        view.backgroundColor = UIColor.init(hexString: GlobalConstants.color.white)
        topBar = TopBar()
        topBar.delegate = self
        topBar.drawBody(leftImage: #imageLiteral(resourceName: "follows"), rightImage: #imageLiteral(resourceName: "settings"), title: "")
        view.addSubview(topBar)
        
        meProfileInfo = MeProfileInfo()
        meProfileInfo.drawBody()
        view.addSubview(meProfileInfo)
        
        publications = Publications()
        publications.drawBody(barHeight: (self.tabBarController?.tabBar.frame.size.height)!, title: "0 Publicaciones")
        view.addSubview(publications)
        
    }
    // MARK: -TopBarDelegate
    func pressLeft(sender: UIButton) {
        // _ = self.navigationController?.popToRootViewController(animated: true)
    }
    func pressRight(sender: UIButton) {
        let editProfileVC = EditProfileViewController()
        editProfileVC.currentUser = self.currentUser
        self.navigationController?.pushViewController(editProfileVC, animated: true)
    }
}
