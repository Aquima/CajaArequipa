//
//  DiscoveryViewController.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 4/1/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit
import Firebase

class DiscoveryViewController: BoxViewController,TopBarDelegate {

    var topBar:TopBar!
    var discoveryList:DiscoveryList!
    var sendData:[User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.createView()
        childAddUsers()
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
        topBar.drawBody(leftImage: #imageLiteral(resourceName: "back"), rightImage: #imageLiteral(resourceName: "hide"), title: "Descubrir Personas")
        view.addSubview(topBar)
        
        discoveryList = DiscoveryList()
        discoveryList.drawBody(barHeight:(self.tabBarController?.tabBar.frame.size.height)!)
        view.addSubview(discoveryList)
        
    }
    // MARK: - TopBarDelegate
    func pressLeft(sender: UIButton) {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    func pressRight(sender: UIButton) {
        
    }
    
    // Retrive User
    func childAddUsers(){
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        ref.child("users").observe(.childAdded, with:  { (snapshot) -> Void in
            // let snap:FIRDataSnapshot
            // print(snapshot.key)
            
            let snapDictionary = (snapshot.value as? Dictionary<String, Any>)!
            
            let userItem:User = User()
            userItem.key = snapshot.key
            userItem.translateToModel(data: snapDictionary)
            ref.child("following").child(userItem.key).observe(.value, with: {(snapshot) -> Void in
                
            })
            ref.queryEqual(toValue: userItem.key).observe(.value, with: {(snapshot) -> Void in
                
            })
            self.sendData.append(userItem)
            self.discoveryList.updateWithData(list: self.sendData)
            
        })
    }

}
