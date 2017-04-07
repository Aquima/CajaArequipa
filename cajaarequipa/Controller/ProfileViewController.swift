//
//  ProfileViewController.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 3/23/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: BoxViewController ,TopBarDelegate{

    var topBar:TopBar!
    var meProfileInfo:MeProfileInfo!
    var publications:Publications!
    var currentUser:User!
    
    var listPhotos:[Photos] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    //    currentUser = User()
        // Do any additional setup after loading the view.
        createView()
        listenerPhotoAdded()
        
        self.currentUser = ApiConsume.sharedInstance.currentUser
        self.meProfileInfo.updateView(user:self.currentUser)
        self.topBar.lblTitle.text = self.currentUser.name.getFirstName()
        
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
            let value = snapshot.value as? Dictionary<String,Any>
            ApiConsume.sharedInstance.currentUser.translateToModel(data: value!)
            self.meProfileInfo.updateView(user:self.currentUser)
            self.topBar.lblTitle.text = self.currentUser.name.getFirstName()
            self.listenerUserChanges()
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    func listenerUserChanges(){

        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        ref.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).observe(.childChanged, with:  { (snapshot) -> Void in
            self.updateValues()
            ref.removeAllObservers()
        })
        

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
    // MARK: - TopBarDelegate
    func pressLeft(sender: UIButton) {
        // _ = self.navigationController?.popToRootViewController(animated: true)
        let discoveryVC:DiscoveryViewController = DiscoveryViewController()
        self.navigationController?.pushViewController(discoveryVC, animated: true)
        
    }
    
    func pressRight(sender: UIButton) {
        
        let editProfileVC = EditProfileViewController()
        editProfileVC.currentUser = self.currentUser
        self.navigationController?.pushViewController(editProfileVC, animated: true)
        
        
    }
    // MARK: - firebase
    func listenerPhotoAdded(){
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        ref.child("photos").child((FIRAuth.auth()?.currentUser?.uid)!).observe(.childAdded, with:  { (snapshot) -> Void in
           // let snap:FIRDataSnapshot
            let itemPhoto = (snapshot.value as? Dictionary<String, Any>)!

            let photoItem = Photos()
            photoItem.translateToModel(data: itemPhoto)
            self.listPhotos.append(photoItem)
            self.publications.updateWithData(list: self.listPhotos)
            
            self.publications.lblTitle.text = "\(self.listPhotos.count) Publicaciones"
        })
    }
}
