//
//  ProfileViewController.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 3/23/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: BoxViewController {

    var topBar:TopBar!
    var meProfileInfo:MeProfileInfo!
    var publications:Publications!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createView()
        var ref: FIRDatabaseReference!
        
        ref = FIRDatabase.database().reference()
        
    //    self.ref.child("users").child("rca_at_g_dot_com").obs
        ref.child("users").child((FIRAuth.auth()?.currentUser?.email?.getIDFromFireBase())!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            print(value)
//            let username = value?["username"] as? String ?? ""
//            let user = User.init(username: username)
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
//        ref.queryOrdered(byChild: "photos/rca_at_g_dot_com").queryEqual(toValue: true)
//            .observe(.value, with: { snapshot in
//                print(snapshot)
//                let value = snapshot.value as? NSDictionary
//                print(value)
//        });
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
        
        publications = Publications()
        publications.drawBody(barHeight: (self.tabBarController?.tabBar.frame.size.height)!, title: "0 Publicaciones")
        view.addSubview(publications)
        
    }

}
