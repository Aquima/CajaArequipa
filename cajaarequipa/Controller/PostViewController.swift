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
                                         "description":self.currentMessage]
                
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
        ref.child("following").child(uid).queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let following = snapshot.value as? [String : AnyObject] {
                for (key , _) in following {
                   
                    //let postFollowers:[String:Any] = [uid:true]
                    ref.child("timeline").child(key).child(uidPhoto).updateChildValues(post)
                   
                }
            }
            
        })
        
        ref.removeAllObservers()
        
    }
//    func timelineFromUsers(keyUser:String){
//        //   let uid = FIRAuth.auth()!.currentUser!.uid
//        let ref = FIRDatabase.database().reference()
//        ref.child("photos").child(keyUser).queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
//            
//            if let following = snapshot.value as? [String : AnyObject] {
//                for (keyPhoto , data) in following {
//                    let postTimeline = data as? Dictionary<String,Any>
//                    //let postFollowers:[String:Any] = [uid:true]
//                    ref.child("timeline").child(keyUser).child(keyPhoto).updateChildValues(postTimeline)
//                    
//                }
//            }
//            
//        })
//        
//        ref.removeAllObservers()
//    }
    
}
