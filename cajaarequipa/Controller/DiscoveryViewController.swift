//
//  DiscoveryViewController.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 4/1/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit
import Firebase

class DiscoveryViewController: BoxViewController,TopBarDelegate,DiscoveryListDelegate {

    var topBar:TopBar!
    var discoveryList:DiscoveryList!
    var sendData:[User] = []
    
    var pageNumber = 1
    var isLoading = false
    
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
        discoveryList.delegate = self
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

        ref.child("users").queryOrderedByKey().queryLimited(toLast: 5).observe(.childAdded, with:  { (snapshot) -> Void in

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
    func checkFollowing(indexPath: IndexPath, user:User) {
        
        let uid = FIRAuth.auth()!.currentUser!.uid
        let ref = FIRDatabase.database().reference()
        ref.child("following").child(uid).queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let following = snapshot.value as? [String : AnyObject] {
                for (key , _) in following {
                    if key == user.key {
                        user.isFollowing = true
                        let cell:UserTableViewCell = self.discoveryList.tableView.cellForRow(at: indexPath) as! UserTableViewCell
                        cell.checkFollow(user: user)
                    }
                }
            }
            
        })
       
        ref.removeAllObservers()
        
    }

    func updateCheckFollowing(indexPath: IndexPath, user:User) {
        
        let uid = FIRAuth.auth()!.currentUser!.uid
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()

        if user.isFollowing == true {
            user.isFollowing = false
            ref.child("following").child(uid).child(user.key).removeValue()
            if  user.followers > 1 {
                user.followers = (user.followers - 1)
                let postUser:[String:Any] = ["followers":user.followers]
                ref.child("users").child(user.key).updateChildValues(postUser)
            }
            let cell:UserTableViewCell = self.discoveryList.tableView.cellForRow(at: indexPath) as! UserTableViewCell
            cell.checkFollow(user: user)
        }else{
            let post:[String:Any] = [user.key:true]
            user.isFollowing = true
            ref.child("following").child(uid).updateChildValues(post)
            user.followers = (user.followers + 1)
            user.follows = (user.follows + 1)
            let postUser:[String:Any] = ["followers":user.followers,
                                         "follows":user.follows]
            ref.child("users").child(user.key).updateChildValues(postUser)
            let cell:UserTableViewCell = self.discoveryList.tableView.cellForRow(at: indexPath) as! UserTableViewCell
            cell.checkFollow(user: user)
        }
       

        ref.removeAllObservers()
 
    }

    func loadNewUsers(offset : Int,user:User){
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        
        ref.child("users").queryOrderedByKey().queryLimited(toLast: 5).queryStarting(atValue: user.key).observe(.value, with:  { (snapshot) -> Void in
            
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
