//
//  EditProfileViewController.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 3/27/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit

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
        
        view.backgroundColor = UIColor.init(hexString: GlobalConstants.color.white)
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

    }
    // MARK: - TopBarDelegate
    func pressLeft(sender: UIButton) {
         _ = self.navigationController?.popToRootViewController(animated: true)
    }
    func pressRight(sender: UIButton) {
       // editing icon
    }
    // MARK: - Actions
    func goCamPro(sender: UIButton){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
            
        }
    }
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            form.imgProfile.image = image
            form.imgProfile.contentMode = .scaleAspectFit

         //call storage
            
            self.dismiss(animated: true, completion: nil)
        }
    }
}
