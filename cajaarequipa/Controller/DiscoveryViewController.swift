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
        retriveUsers()
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
    func retriveUsers(){
       
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        ref.child("users").queryOrderedByKey().queryLimited(toFirst: 5).observeSingleEvent(of: .value, with:  { (snapshot) -> Void in
        
       
            if (snapshot.value is NSNull) {
                print("user data not found")
            } else {
                
                for child in snapshot.children {
                    let data = child as! FIRDataSnapshot
                    let snapDictionary:Dictionary = data.value! as! Dictionary<String, Any>

                    let userItem:User = User()
                    userItem.key = data.key
                    userItem.translateToModel(data: snapDictionary)
                    ref.child("following").child(userItem.key).observe(.value, with: {(snapshot) -> Void in
                        
                    })
                    ref.queryEqual(toValue: userItem.key).observe(.value, with: {(snapshot) -> Void in
                        
                    })
                    self.sendData.append(userItem)
                    
                }
                self.discoveryList.updateWithData(list: self.sendData)
                ref.removeAllObservers()
            }
  
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
            
            ref.child("followers").child(user.key).child(uid).removeValue()

            if  user.followers > 1 {
                user.followers = (user.followers - 1)

            }
            self.removeTimelineFromUsers(keyUser: user.key)
            self.discoveryList.tableView.isScrollEnabled = false
            let cell:UserTableViewCell = self.discoveryList.tableView.cellForRow(at: indexPath) as! UserTableViewCell
            cell.checkFollow(user: user)
            self.discoveryList.tableView.isScrollEnabled = true
        }else{
            let post:[String:Any] = [user.key:true]
            user.isFollowing = true
            ref.child("following").child(uid).updateChildValues(post)
            
            let postFollowers:[String:Any] = [uid:true]
            ref.child("followers").child(user.key).updateChildValues(postFollowers)
            
            self.timelineFromUsers(user: user)
            
            user.followers = (user.followers + 1)
            user.follows = (user.follows + 1)
            self.discoveryList.tableView.isScrollEnabled = false
            let cell:UserTableViewCell = self.discoveryList.tableView.cellForRow(at: indexPath) as! UserTableViewCell
            cell.checkFollow(user: user)
            self.discoveryList.tableView.isScrollEnabled = true
            
        }
       

        ref.removeAllObservers()
 
    }

    func loadNewUsers(offset : Int,user:User){
        self.discoveryList.isLoading = true
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        ref.child("users").queryOrderedByKey().queryStarting(atValue: user.key).queryLimited(toFirst: UInt(offset)*5).observeSingleEvent(of: .value, with:  { (snapshot) -> Void in

            if (snapshot.value is NSNull) {
                print("user data not found")
            } else {
                self.sendData.removeLast()
                for child in snapshot.children {
                    let data = child as! FIRDataSnapshot
                    let snapDictionary:Dictionary = data.value! as! Dictionary<String, Any>
         
                    let userItem:User = User()
                    userItem.key = data.key
                    userItem.translateToModel(data: snapDictionary)

                    self.sendData.append(userItem)
                    
                }
                self.discoveryList.updateWithData(list: self.sendData)
                ref.removeAllObservers()
            }
 
        })
        //ref.removeAllObservers()
    }
    // MARK: - Timeline
    func timelineFromUsers(user:User){
        let uid = FIRAuth.auth()!.currentUser!.uid
        let ref = FIRDatabase.database().reference()
        //this a reference from get photos
       
        ref.child("photos").child(user.key).queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let following = snapshot.value as? [String : AnyObject] {
                for (keyPhoto , data) in following {
                    var postTimeline:Dictionary<String,Any> = (data as? Dictionary<String,Any>)!
                    let userData:Dictionary<String,Any> = ["pictureurl":user.pictureUrl.absoluteString,
                                                           "name":user.name]
                    postTimeline["user"] = userData
                    ref.child("timeline").child(uid).child(keyPhoto).updateChildValues(postTimeline)
                    
                }
            }
            
        })
        
        ref.removeAllObservers()
    }
    // MARK: - Timeline
    func removeTimelineFromUsers(keyUser:String){
        let uid = FIRAuth.auth()!.currentUser!.uid
        let ref = FIRDatabase.database().reference()
        //this a reference from get photos
        ref.child("photos").child(keyUser).queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let following = snapshot.value as? [String : AnyObject] {
                for (keyPhoto , _) in following {
                   
                    ref.child("timeline").child(uid).child(keyPhoto).removeValue()
                    
                }
            }
            
        })
        
        ref.removeAllObservers()
    }

}
