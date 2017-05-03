//
//  SearchViewController.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 3/23/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit
import Firebase

class SearchViewController: BoxViewController, UISearchBarDelegate,UserListDelegate {

    var searchBar:UISearchBar = UISearchBar()
    var discoveryList:UserList!
    var sendData:[User] = []
    
    var pageNumber = 1
    var isLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
   //     retriveUsers()
        createView()
//        retriveUsersFromComments(value: "-KilLaTaK8XwdiBrW5vW")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func createView(){
        searchBar.frame = CGRect(x:(screenSize.width-320*valuePro)/2, y: 18*valuePro, width: 320*valuePro, height: 40*valuePro)
        searchBar.barTintColor = UIColor.init(hexString: GlobalConstants.color.blue)
        searchBar.delegate = self
        searchBar.searchBarStyle = .prominent
        searchBar.placeholder = "Buscar"
        view.addSubview(searchBar)
        
        discoveryList = UserList()
        discoveryList.delegate = self
        discoveryList.drawBody(barHeight:(self.tabBarController?.tabBar.frame.size.height)!)
        view.addSubview(discoveryList)
        
        discoveryList.showNoDataMessage(show: false)
        let tapList = UITapGestureRecognizer(target: self, action:#selector(handleTap(sender:)))
        
        discoveryList.addGestureRecognizer(tapList)
     
    }

    func handleTap(sender: UITapGestureRecognizer? = nil) {
        // handling code
        searchBar.resignFirstResponder()
    }

    func retriveUsersFromValue(value:String){
        
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        ref.child("users").queryOrdered(byChild: "components/\(value)").queryEqual(toValue: true).observeSingleEvent(of: .value, with:  { (snapshot) -> Void in
            
            if (snapshot.value is NSNull) {
                print("retriveUsers")
                self.discoveryList.showNoDataMessage(show: false)
                
            } else {
                self.discoveryList.showNoDataMessage(show: true)
                self.sendData.removeAll()
                for child in snapshot.children {
                    let data = child as! FIRDataSnapshot
                    let snapDictionary:Dictionary = data.value! as! Dictionary<String, Any>
                    
                    let userItem:User = User()
                    userItem.key = data.key
                    userItem.translateToModel(data: snapDictionary)
                    print(userItem.name)
                    self.sendData.append(userItem)
                    
                }
                self.discoveryList.updateWithData(list: self.sendData)
                ref.removeAllObservers()

            }
            
        })
        
    }
    func retriveUsersFromComments(value:String){
        
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        ref.child("photos").child(value).observeSingleEvent(of: .value, with:  { (snapshot) -> Void in
            
            if (snapshot.value is NSNull) {
                print("retriveUsers")
                self.discoveryList.showNoDataMessage(show: false)
                
            } else {
                self.discoveryList.showNoDataMessage(show: true)
                self.sendData.removeAll()
                for child in snapshot.children {
                    let data = child as! FIRDataSnapshot
                    let snapDictionary:Dictionary = data.value! as! Dictionary<String, Any>
                    
                    let userItem:User = User()
                    userItem.key = data.key
                    userItem.translateToModel(data: snapDictionary)
                    print(userItem.name)
                    self.sendData.append(userItem)
                    
                }
                self.discoveryList.updateWithData(list: self.sendData)
                ref.removeAllObservers()
                
            }
            
        })
        
    }
    

    // MARK: - Retrive User
    func retriveUsers(){
        
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with:  { (snapshot) -> Void in
            
            
            if (snapshot.value is NSNull) {
                print("retriveUsers")
            } else {
                
                for child in snapshot.children {
                    let data = child as! FIRDataSnapshot
                    let snapDictionary:Dictionary = data.value! as! Dictionary<String, Any>
                    
                    let userItem:User = User()
                    userItem.key = data.key
                    userItem.translateToModel(data: snapDictionary)
                    let refUpdate:FIRDatabaseReference = FIRDatabase.database().reference()
                  //  let fullArr = userItem.name.components(separatedBy: "")
                    let string : String = userItem.name.trimmingCharacters(in: .whitespaces)
                
                  //  let trimmedString = string.trimmingCharacters(in: .whitespaces)
                    print("Name \(string)")
                    let characters = Array(string.characters)
                    var components:Dictionary<String,Any> = [:]
                    for char in characters {
                      //  if char != " " {
                            
                            components["\(char)"] = true
                     //   }
                    }
                    //permutar
                    let fullArr = string.components(separatedBy: " ")
                    print("Full Arr \(fullArr)")
                    for partNames:String in fullArr {
                        let newComponents:String = partNames.trimmingCharacters(in: .whitespaces)
                        if newComponents.unicodeScalars.count >= 1 {
                            print("newComponents \(newComponents) \(newComponents.unicodeScalars.count)")
                            for indexTemp in 1...newComponents.unicodeScalars.count {
                                let index = newComponents.index(newComponents.startIndex, offsetBy: indexTemp)
                                components["\(newComponents.substring(to: index))"] = true
                            }
                        }
                       
                    }
                    print(components)
                    refUpdate.child("users").child(userItem.key).child("components").updateChildValues(components)
                    
                }
                 ref.removeAllObservers()
            }
            
        })
        
    }
    // MARK: - UISearchBarDelegate
    func retriveResult(){
        let searchText:String = self.searchBar.text!
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        ref.child("users").queryOrdered(byChild: "components/\(searchText.uppercased())").queryEqual(toValue: true).observeSingleEvent(of: .value, with:  { (snapshot) -> Void in
            
            if (snapshot.value is NSNull) {
                print("retriveUsers")
                self.sendData.removeAll()
                self.discoveryList.showNoDataMessage(show: false)
                
            } else {
                self.discoveryList.showNoDataMessage(show: true)
                self.sendData.removeAll()
                print("====================== Contador de Resultados por palabra \(searchText) \(snapshot.childrenCount)")
                for child in snapshot.children {
                    let data = child as! FIRDataSnapshot
                    let snapDictionary:Dictionary = data.value! as! Dictionary<String, Any>
                    
                    let userItem:User = User()
                    userItem.key = data.key
                    userItem.translateToModel(data: snapDictionary)
                    print(userItem.name)
                    self.sendData.append(userItem)
                    
                }
                self.discoveryList.updateWithData(list: self.sendData)
                ref.removeAllObservers()
                
            }
            
        })
        
    }

    // called whenever text is changed.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      //  myLabel.text = searchText
        
        if  searchText == "" {
            self.sendData.removeAll()
            self.discoveryList.showNoDataMessage(show: false)
        }else{
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(retriveResult), object: nil)
            self.perform(#selector(retriveResult), with: nil, afterDelay: 0.5)
         //   retriveUsersFromValue(value: searchText.uppercased())
        }
    }
    
    // called when cancel button is clicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
       // myLabel.text = ""
      //  mySearchBar.text = ""
    }
    
    // called when search button is clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       // myLabel.text = "Searching"
        searchBar.text = ""
        self.view.endEditing(true)
    }
    // MARK: - SearBarDelegate
    internal func openDetail(indexPath:IndexPath, user:User){
        let publicProfileVC:PublicProfileViewController = PublicProfileViewController()
        publicProfileVC.currentUser = user
        //  timeline.userPropertier?.key = timeline.userPropertier?.key
        self.navigationController?.pushViewController(publicProfileVC, animated: true)

    }
    internal func checkFollowing(indexPath: IndexPath, user:User) {
//        
//        let uid = FIRAuth.auth()!.currentUser!.uid
//        let ref = FIRDatabase.database().reference()
//        ref.child("following").child(uid).queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
//            if (snapshot.value is NSNull) {
//                print("checkFollowing")
//            } else {
//                if let following = snapshot.value as? [String : AnyObject] {
//                    for (key , _) in following {
//                        if key == user.key {
//                            user.isFollowing = true
//                            let cell:UserTableViewCell = self.discoveryList.tableView.cellForRow(at: indexPath) as! UserTableViewCell
//                            cell.checkFollow(user: user)
//                        }
//                    }
//                }
//            }
//            
//        })
//        
//        ref.removeAllObservers()
//        
    }
    
    internal func updateCheckFollowing(indexPath: IndexPath, user:User) {
        
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
            let cell:UserItemTableViewCell = self.discoveryList.tableView.cellForRow(at: indexPath) as! UserItemTableViewCell
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
            let cell:UserItemTableViewCell = self.discoveryList.tableView.cellForRow(at: indexPath) as! UserItemTableViewCell
            cell.checkFollow(user: user)
            self.discoveryList.tableView.isScrollEnabled = true
            
        }
        
        
        ref.removeAllObservers()
        
    }
    
    internal func loadNewUsers(offset : Int,user:User){
//        self.discoveryList.isLoading = true
//        
//        var ref: FIRDatabaseReference!
//        ref = FIRDatabase.database().reference()
//        ref.child("users").queryOrderedByKey().queryStarting(atValue: user.key).queryLimited(toFirst: UInt(offset)*5).observeSingleEvent(of: .value, with:  { (snapshot) -> Void in
//            
//            if (snapshot.value is NSNull) {
//                print("loadNewUsers")
//            } else {
//                self.sendData.removeLast()
//                for child in snapshot.children {
//                    let data = child as! FIRDataSnapshot
//                    let snapDictionary:Dictionary = data.value! as! Dictionary<String, Any>
//                    
//                    let userItem:User = User()
//                    userItem.key = data.key
//                    userItem.translateToModel(data: snapDictionary)
//                    print("\(userItem.name)")
//                    self.sendData.append(userItem)
//                    
//                    
//                }
//                if snapshot.childrenCount > 1 {
//                    self.discoveryList.isLoading = false
//                    self.discoveryList.updateWithData(list: self.sendData)
//                }else{
//                    self.discoveryList.isLoading = true
//                }
//                
//                ref.removeAllObservers()
//            }
//            
//        })
//        
    }
    // MARK: - Timeline
    func timelineFromUsers(user:User){
        let uid = FIRAuth.auth()!.currentUser!.uid
        let ref = FIRDatabase.database().reference()
        //this a reference from get photos
        
        ref.child("photos").child(user.key).queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            if (snapshot.value is NSNull) {
                print("timelineFromUsers")
            } else {
                if let following = snapshot.value as? [String : AnyObject] {
                    for (keyPhoto , data) in following {
                        var postTimeline:Dictionary<String,Any> = (data as? Dictionary<String,Any>)!
                        let pictureurl:String = (user.pictureUrl != nil) ? user.pictureUrl.absoluteString : ""
                        let userData:Dictionary<String,Any> = ["pictureurl":pictureurl,
                                                               "name":user.name,
                                                               "uid":user.key]
                        postTimeline["user"] = userData
                        ref.child("timeline").child(uid).child(keyPhoto).updateChildValues(postTimeline)
                        
                    }
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
            if (snapshot.value is NSNull) {
                print("removeTimelineFromUsers")
            } else {
                if let following = snapshot.value as? [String : AnyObject] {
                    for (keyPhoto , _) in following {
                        
                        ref.child("timeline").child(uid).child(keyPhoto).removeValue()
                        
                    }
                }
                
            }
            
        })
        
        ref.removeAllObservers()
    }

}
