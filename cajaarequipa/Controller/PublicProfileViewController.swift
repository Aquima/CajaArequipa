//
//  PublicProfileViewController.swift
//  cajaarequipa
//
//  Created by Nara on 4/9/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class PublicProfileViewController: BoxViewController,TopBarDelegate,PublicProfileInfoDelegate,MFMailComposeViewControllerDelegate {
    var topBar:TopBar!
    var publicProfileInfo:PublicProfileInfo!
    var publications:Publications!
    var currentUser:User!
    
    var listPhotos:[Photos] = []
    var refPhotoAdded: FIRDatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createView()
        listenerPhotoAdded()
        updateValues()
        self.publicProfileInfo.updateView(user:self.currentUser)
        checkFollowing(user: self.currentUser)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func updateValues(){
        let uid:String = self.currentUser.key
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? Dictionary<String,Any>
            
            self.currentUser.translateToModel(data: value!)
            self.currentUser.uid = snapshot.key
            self.currentUser.key = snapshot.key
            self.publicProfileInfo.updateView(user:self.currentUser)

         //   self.listenerUserChanges()
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    func listenerUserChanges(){
        let uid:String = self.currentUser.key
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        ref.child("users").child(uid).observe(.childChanged, with:  { (snapshot) -> Void in
            self.updateValues()
            ref.removeAllObservers()
        })
        
        
    }
    // MARK: - Navigation
    func createView(){
        
        view.backgroundColor = UIColor.init(hexString: GlobalConstants.color.white)
        topBar = TopBar()
        topBar.delegate = self
        topBar.drawBody(leftImage: #imageLiteral(resourceName: "back"), rightImage: #imageLiteral(resourceName: "hide"), title: "Perfil")
        view.addSubview(topBar)
        
        publicProfileInfo = PublicProfileInfo()
        publicProfileInfo.drawBody()
        publicProfileInfo.delegate = self
        view.addSubview(publicProfileInfo)
        
        publications = Publications()
        publications.drawBodyPublic(barHeight: (self.tabBarController?.tabBar.frame.size.height)!, title: "0 Publicaciones")
        view.addSubview(publications)
        
    }
    // MARK: - TopBarDelegate
    internal func pressLeft(sender: UIButton) {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    internal func pressRight(sender: UIButton) {
        // no actions
    }
    // MARK: - firebase
    func listenerPhotoAdded(){
        let uid:String = self.currentUser.key

        refPhotoAdded = FIRDatabase.database().reference()
        refPhotoAdded.child("photos").child(uid).observe(.childAdded, with:  { (snapshot) -> Void in
            // let snap:FIRDataSnapshot
            let itemPhoto = (snapshot.value as? Dictionary<String, Any>)!
            
            let photoItem = Photos()
            photoItem.translateToModel(data: itemPhoto)
            self.listPhotos.append(photoItem)
            self.publications.updateWithData(list: self.listPhotos)
            
            self.publications.lblTitle.text = "\(self.listPhotos.count) Publicaciones"
        })
    }

    // MARK: - PublicProfileDelegate
    internal func contactWithUser(user:User){
        if user.email != nil {
            if !MFMailComposeViewController.canSendMail() {
                print("Mail services are not available")
                return
            }
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            
            // Configure the fields of the interface.
            composeVC.setToRecipients([user.email])
            composeVC.setSubject("Contactame!")
      //      composeVC.setMessageBody("Hello from California!", isHTML: false)
            
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
        }
    }
    internal func followWithUser(user:User){
        if user.key != nil {
            updateCheckFollowing(user: user)
        }

    }
    // MARK: - Firebase
    
    func updateCheckFollowing(user:User) {
        
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
            self.publicProfileInfo.updateView(user: user)
        }else{
            let post:[String:Any] = [user.key:true]
            user.isFollowing = true
            ref.child("following").child(uid).updateChildValues(post)
            
            let postFollowers:[String:Any] = [uid:true]
            ref.child("followers").child(user.key).updateChildValues(postFollowers)
            
            self.timelineFromUsers(user: user)
            
            user.followers = (user.followers + 1)
            user.follows = (user.follows + 1)
            self.publicProfileInfo.updateView(user: user)
        }

        ref.removeAllObservers()
        
    }
    // MARK: - Timeline Firebase
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
    func checkFollowing(user:User) {
        
        let uid = FIRAuth.auth()!.currentUser!.uid
        let ref = FIRDatabase.database().reference()
        ref.child("following").child(uid).queryOrderedByKey().queryEqual(toValue: user.key).observeSingleEvent(of: .value, with: { snapshot in
            if (snapshot.value is NSNull) {
                print("checkFollowing")
            } else {
                if let following = snapshot.value as? [String : AnyObject] {
                    for (key , _) in following {
                        if key == user.key {
                            user.isFollowing = true
                            self.publicProfileInfo.updateView(user: user)
                        }
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
            self.publicProfileInfo.updateView(user: user)
        }else{
            let post:[String:Any] = [user.key:true]
            user.isFollowing = true
            ref.child("following").child(uid).updateChildValues(post)
            
            let postFollowers:[String:Any] = [uid:true]
            ref.child("followers").child(user.key).updateChildValues(postFollowers)
            
            self.timelineFromUsers(user: user)
            
            user.followers = (user.followers + 1)
            user.follows = (user.follows + 1)
            self.publicProfileInfo.updateView(user: user)
        }
        
        
        ref.removeAllObservers()
        
    }
    // MARK: - Mail Composer
    internal func mailComposeController(_ controller: MFMailComposeViewController,
                                        didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
    // MARK: - ViewController
    override func viewDidDisappear(_ animated: Bool) {
        refPhotoAdded.removeAllObservers()
    }
}
