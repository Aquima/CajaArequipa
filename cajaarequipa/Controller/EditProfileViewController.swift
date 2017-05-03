//
//  EditProfileViewController.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 3/27/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit
import Firebase

class EditProfileViewController: BoxViewController,TopBarDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,FormEditProfileDelegate  {
 


    var topBar:TopBar!
    var form:FormEditProfile!
    var currentUser:User!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation
    func createView(){
        
        view.backgroundColor = UIColor.init(hexString: GlobalConstants.color.grayMedium)
        topBar = TopBar()
        topBar.delegate = self
        topBar.drawBody(leftImage: #imageLiteral(resourceName: "back"), rightImage: #imageLiteral(resourceName: "hide"), title: "Configuración")
        view.addSubview(topBar)
        
        form = FormEditProfile()
        form.delegate = self
        form.drawBody(barHeight: (self.tabBarController?.tabBar.frame.size.height)!)
        form.updateView()
        form.updateViewWithData(user: currentUser)
        view.addSubview(form)

        let tapForm = UITapGestureRecognizer(target: self, action:#selector(handleTap(sender:)))

        form.addGestureRecognizer(tapForm)
    }
    // MARK: - TopBarDelegate
    internal func pressLeft(sender: UIButton) {
         _ = self.navigationController?.popToRootViewController(animated: true)
    }
    internal func pressRight(sender: UIButton) {
       // editing icon
    }
    // MARK: - Actions
    internal func logOut() {
    
        let alertController = UIAlertController(title: "¿Esta seguro de cerrar sesión?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let saveAction = UIAlertAction(title: "Si", style: UIAlertActionStyle.default, handler: {
            alert -> Void in

            try! FIRAuth.auth()!.signOut()
            let notificationName = Notification.Name("goIntro")
            NotificationCenter.default.post(name: notificationName, object: nil)
            
        })
        
        let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)

    }
    internal func goCamPro(sender: UIButton){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
            
        }
    }
    internal func saveInfo(describe: String, website: String, email: String) {
        //cuando creo delegar succes completed y  crear email y password al currentUser
        let post:[String:Any] = ["email": email ,
                                 "website":website,
                                 "description":describe
        ]
        
        var ref: FIRDatabaseReference!
        //  FIRAuth.auth()?.currentUser?.uid ?? String()
        ref = FIRDatabase.database().reference()
        //  ref.child("users/\(email.getIDFromFireBase())").updateChildValues(post)
        ref.child("users/\((FIRAuth.auth()?.currentUser?.uid)!)").updateChildValues(post, withCompletionBlock:  { (error:Error?, ref:FIRDatabaseReference!) in
     
            self.form.stopAnimation()
            _ = self.navigationController?.popToRootViewController(animated: true)
        })
    }
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            form.imgProfile.image = image
        //    form.imgProfile.contentMode = .scaleAspectFit

         //call storage
            
            self.dismiss(animated: true, completion: nil)
            
            var data = Data()
          //  image.resized(withPercentage: 0.3)
            data = UIImageJPEGRepresentation(image.resized(withPercentage: 0.3)!, 0.8)!
            //create reference
            let storage = FIRStorage.storage()
            let storageRef = storage.reference()
            
            // set upload path
            let filePath = "profile/\(FIRAuth.auth()!.currentUser!.uid)"
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpg"

            storageRef.child(filePath).put(data, metadata: metaData){(metaData,error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }else{
                    //storage DownloadURL
                    let downloadURL = metaData!.downloadURL()!.absoluteString

                    let post:[String:Any] = ["pictureurl": downloadURL]
                    
                    var ref: FIRDatabaseReference!
                    ref = FIRDatabase.database().reference()
                    ref.child("users/\((FIRAuth.auth()?.currentUser?.uid)!)").updateChildValues(post, withCompletionBlock:  { (error:Error?, ref:FIRDatabaseReference!) in
                        //print("This never prints in the console")
                        self.form.stopPhotoAnimation()
                        
                    })
                }
                
            }
        }else{
            self.form.stopPhotoAnimation()
        }
    }
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        // handling code
        form.resignFirstResponderList()
    }
}
