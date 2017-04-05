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
        let photoRef = ref.child("photos/\((FIRAuth.auth()?.currentUser?.uid)!)")
        let key = photoRef.childByAutoId()
        // set upload path
        let filePath = "photos/\((FIRAuth.auth()?.currentUser?.uid)!)/\(key.key)"
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
                
                key.updateChildValues(post, withCompletionBlock:  { (error:Error?, ref:FIRDatabaseReference!) in
                sender.isHidden = false
                    
                })
            }
            
        }
        _ = self.navigationController?.popToRootViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
        tabBarController?.selectedIndex = 0

    }
    

}
