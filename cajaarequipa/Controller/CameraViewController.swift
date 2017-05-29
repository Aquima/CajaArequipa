//
//  CameraViewController.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 3/23/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit
import AVFoundation


class CameraViewController: BoxViewController,CustomCameraViewDelegate,TopBarDelegate,OptionsCameraDelegate,FusumaDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var cameraView:CustomCameraView = CustomCameraView()
    var optionsCameraView:OptionsCamera = OptionsCamera()
    var contentCamera:UIView = UIView()
    
    var topBar:TopBar!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        
        view.addSubview(contentCamera)

        cameraView.createComponents()
        cameraView.drawBody()
        cameraView.delegate = self
        
        contentCamera.addSubview(cameraView)
        if cameraView.cameraIsAvailable() == true {
        //     optionsCameraView.hasFlash = (cameraView.device?.hasFlash)!
        }else{
             optionsCameraView.hasFlash = false
        }
       
        optionsCameraView.createComponents()
        optionsCameraView.delegate = self
        self.view.addSubview(optionsCameraView)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {

            cameraView.stopCamera()
        
    }
    override func viewWillAppear(_ animated: Bool) {
     
        
        
        cameraView.startCamera()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    // MARK: - Camera
    internal func cameraShotFinished(image:UIImage){

        let postVC:PostViewController = PostViewController()
        postVC.currentImage = image
        self.navigationController?.pushViewController(postVC, animated: true)
        
    }
    // MARK: - Navigation
    func createView(){
        
        view.backgroundColor = UIColor.init(hexString: GlobalConstants.color.white)
        topBar = TopBar()
        topBar.delegate = self
        topBar.drawBody(leftImage: #imageLiteral(resourceName: "cancel"), rightImage: #imageLiteral(resourceName: "hide"), title: "Foto")
        view.addSubview(topBar)
        
        
      
    }
    // MARK: - TopViewDelegate
    func pressLeft(sender:UIButton){
        //go Home
         self.tabBarController?.tabBar.isHidden = false
        tabBarController?.selectedIndex = 0
    }
    func pressRight(sender:UIButton){
        //go To publish
       // self.tabBarController?.tabBar.isHidden = false
    }

    // MARK: - OptionsCameraView
    internal func pressFlipOn(){
        self.cameraView.flipButtonPressed()
    }
    internal func pressFlashOn(sender:UIButton){
        self.cameraView.flashButtonPressed(sender:sender)
    }
    internal func pressShotOn(sender:UIButton){
        self.cameraView.shotButtonPressed(sender:sender)
    }
    internal func pressLibraryOn() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
            let cameraVC = FusumaViewController()
            cameraVC.delegate = self
            self.present(cameraVC, animated: true, completion: nil)
//            imagePicker.delegate = self
//            imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum;
//            imagePicker.allowsEditing = false
//            
//            self.present(imagePicker, animated: true, completion: nil)
            
        }
    }
    internal func pressCameraOn() {
       // self.cameraView.startCamera()
       
    }
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.dismiss(animated: true, completion: nil)
            let postVC:PostViewController = PostViewController()
            postVC.currentImage = image
            self.navigationController?.pushViewController(postVC, animated: true)
            //go to share
            
        }else{
            self.cameraView.startCamera()
        }
    }
// MARK: - FUSUMADELEGATE
    // MARK: FusumaDelegate Protocol
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        switch source {
        case .camera:
            print("Image captured from Camera")
        case .library:
            print("Image selected from Camera Roll")
        default:
            print("Image selected")
        }
        let postVC:PostViewController = PostViewController()
        postVC.currentImage = image
        self.navigationController?.pushViewController(postVC, animated: true)

    //    imageView.image = image
    }
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode, metaData: ImageMetadata) {
//        print("Image mediatype: \(metaData.mediaType)")
//        print("Source image size: \(metaData.pixelWidth)x\(metaData.pixelHeight)")
//        print("Creation date: \(metaData.creationDate)")
//        print("Modification date: \(metaData.modificationDate)")
//        print("Video duration: \(metaData.duration)")
//        print("Is favourite: \(metaData.isFavourite)")
//        print("Is hidden: \(metaData.isHidden)")
//        print("Location: \(metaData.location)")
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        print("video completed and output to file: \(fileURL)")
      //  self.fileUrlLabel.text = "file output to: \(fileURL.absoluteString)"
    }
    
    func fusumaDismissedWithImage(_ image: UIImage, source: FusumaMode) {
        switch source {
        case .camera:
            print("Called just after dismissed FusumaViewController using Camera")
        case .library:
            print("Called just after dismissed FusumaViewController using Camera Roll")
        default:
            print("Called just after dismissed FusumaViewController")
        }
    }
    
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
        
        let alert = UIAlertController(title: "Access Requested", message: "Saving image needs to access your photo album", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (action) -> Void in
            
            if let url = URL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.shared.openURL(url)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func fusumaClosed() {
        print("Called when the FusumaViewController disappeared")
    }
    
    func fusumaWillClosed() {
        print("Called when the close button is pressed")
    }

}
