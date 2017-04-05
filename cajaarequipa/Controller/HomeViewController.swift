//
//  HomeViewController.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 3/23/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: BoxViewController,TopBarDelegate {

     var topBar:TopBar!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.createView()
        
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        ref.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
//            let value = snapshot.value as? Dictionary<String,Any>
//            self.currentUser.translateToModel(data: value! )
//            self.meProfileInfo.updateView(user:self.currentUser)
//            self.topBar.lblTitle.text = self.currentUser.name.getFirstName()
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - View
    func createView(){
        
        view.backgroundColor = UIColor.init(hexString: GlobalConstants.color.white)
        topBar = TopBar()
        topBar.delegate = self
        topBar.drawBody(leftImage: #imageLiteral(resourceName: "hide"), rightImage: #imageLiteral(resourceName: "hide"), title: "Inicio")
        view.addSubview(topBar)
  
    }
    // MARK: - TopBarDelegate
    func pressLeft(sender: UIButton) {
        //
    }
    
    func pressRight(sender: UIButton) {
        
    }

    // MARK: - Firebase
    func retriveTimeLine(){
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        ref.child("following").queryOrderedByKey().observe(.childAdded, with:  { (snapshot) -> Void in
            // let snap:FIRDataSnapshot
            // print(snapshot.key)
            
//            let snapDictionary = (snapshot.value as? Dictionary<String, Any>)!
//            
//            let userItem:User = User()
//            userItem.key = snapshot.key
//            userItem.translateToModel(data: snapDictionary)
//            ref.child("following").child(userItem.key).observe(.value, with: {(snapshot) -> Void in
//                
//            })
//            ref.queryEqual(toValue: userItem.key).observe(.value, with: {(snapshot) -> Void in
//                
//            })
  //          self.sendData.append(userItem)
  //          self.discoveryList.updateWithData(list: self.sendData)
        })

    }
    
}
