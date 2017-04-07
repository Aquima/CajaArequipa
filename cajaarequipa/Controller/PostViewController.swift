//
//  PostViewController.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 3/30/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit
import Firebase

class PostViewController: BoxViewController,TopBarDelegate {
    
    var footerPhoto:FooterPhoto!
    var topBar:TopBar!

    var currentImage:UIImage!
    var currentMessage:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        footerPhoto.updateView(image: currentImage)
    }
    // MARK: - View
    func createView(){
        
        view.backgroundColor = UIColor.init(hexString: GlobalConstants.color.white)
        topBar = TopBar()
        topBar.delegate = self
        topBar.drawBody(leftImage: #imageLiteral(resourceName: "back"), rightImage: #imageLiteral(resourceName: "publish"), title: "Publicar")
        view.addSubview(topBar)

        footerPhoto = FooterPhoto()
        footerPhoto.drawBody()
        view.addSubview(footerPhoto)
        
    }
    // MARK: - TopViewDelegate
    func pressLeft(sender:UIButton){
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    func pressRight(sender:UIButton){
        sender.isHidden = true
        //go To publish
        // self.tabBarController?.tabBar.isHidden = false

        var data = Data()
        //  image.resized(withPercentage: 0.3)
        data = UIImageJPEGRepresentation(currentImage.resized(withPercentage: 0.3)!, 0.8)!
        //create reference
        let storage = FIRStorage.storage()
        let storageRef = storage.reference()
        
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        let keyUser:String = (FIRAuth.auth()?.currentUser?.uid)!
        let photoRef = ref.child("photos/\(keyUser)")
        let keyPhoto = photoRef.childByAutoId()
        // set upload path
        let filePath = "photos/\(keyUser)/\(keyPhoto.key)"
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.child(filePath).put(data, metadata: metaData){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }else{
                //storage DownloadURL
                let downloadURL = metaData!.downloadURL()!.absoluteString
                self.currentMessage = self.footerPhoto.txtFooter.text
                let post:[String:Any] = ["pictureurl": downloadURL,
                                         "comments":0,
                                         "likes":0,
                                         "description":self.currentMessage,
                                         "timestamp":FIRServerValue.timestamp(),
                                         "isfavorited":false]
                
                keyPhoto.updateChildValues(post, withCompletionBlock:  { (error:Error?, ref:FIRDatabaseReference!) in
                sender.isHidden = false
                    self.postToTimeline(uidPhoto: keyPhoto.key, post: post)
                    //self.timelineFromUsers(keyUser: keyUser)
                })
                
            }
            
        }
        _ = self.navigationController?.popToRootViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
        tabBarController?.selectedIndex = 0

    }
    func postToTimeline(uidPhoto:String,post:Dictionary<String,Any>) {
        
        let uid = FIRAuth.auth()!.currentUser!.uid
        let ref = FIRDatabase.database().reference()
        ref.child("followers").child(uid).queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let following = snapshot.value as? [String : AnyObject] {
                for (key , _) in following {
 
                    self.getUserFromKey(keyUser: key, photo: post, keyPhoto:uidPhoto)
                   
                }
            }
            
        })
        
        ref.removeAllObservers()
        
    }
    func getUserFromKey(keyUser:String,photo:Dictionary<String,Any>,keyPhoto:String){
       
        let ref = FIRDatabase.database().reference()
        ref.child("users").queryOrderedByKey().queryEqual(toValue: keyUser).observeSingleEvent(of: .value, with: { snapshot in
            
            if (snapshot.value is NSNull) {
                print("user data not found")
            } else {
                let userItem:Dictionary<String, Any> = snapshot.value! as! Dictionary<String, Any>
                for child in snapshot.children {
                    let data:FIRDataSnapshot = child as! FIRDataSnapshot
                    print(data.key)
                    let user:User = User()
                    user.key = data.key
                    user.translateToModel(data: userItem)
                    
                    //  let uid = FIRAuth.auth()!.currentUser!.uid
                    let meUser:User = ApiConsume.sharedInstance.currentUser
                    
                    var postTimeline: Dictionary<String,Any> = Dictionary()
                    postTimeline = photo
                    
                    let pictureurl:String = (meUser.pictureUrl != nil) ? meUser.pictureUrl.absoluteString : ""
                    let userData:Dictionary<String,Any> = ["pictureurl":pictureurl,
                                                           "name":meUser.name,
                                                           "uid":meUser.key]
                    postTimeline["user"] = userData
                    //
                    ref.child("timeline").child(user.key).child(keyPhoto).updateChildValues(postTimeline)

                }
               //
                ref.removeAllObservers()
            }
            
        })
        
        ref.removeAllObservers()
    }

    
}
