//
//  DetailPhotoViewController.swift
//  cajaarequipa
//
//  Created by Raul on 5/11/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit
import Firebase
protocol DetailPhotoViewControllerDelegate {
    func completedDeletedPhoto(photo:Photos,index:IndexPath)
}
class DetailPhotoViewController: BoxViewController,TopBarDelegate {

    var delegate:DetailPhotoViewControllerDelegate?
    var topBar:TopBar!
    var detailPhoto:DetailPhoto!
    var currentPhoto:Photos!
    var currentUser:User!
    var isNoDeleteOption:Bool = false
    var currentIndex:IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
        // Do any additional setup after loading the view.
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
        if isNoDeleteOption == false {
             topBar.drawBody(leftImage: #imageLiteral(resourceName: "back"), rightImage: #imageLiteral(resourceName: "moreIcon"), title: "Foto")
        }else{
             topBar.drawBody(leftImage: #imageLiteral(resourceName: "back"), rightImage: #imageLiteral(resourceName: "hide"), title: "Foto")
        }
       
        view.addSubview(topBar)
        
        detailPhoto = DetailPhoto()
     
        detailPhoto.currentUser = self.currentUser
        detailPhoto.drawBody(barHeight:(self.tabBarController?.tabBar.frame.size.height)!)
        detailPhoto.loadWithPhoto(photo: currentPhoto)
        view.addSubview(detailPhoto)
        
        detailPhoto.shareAction = {
            //self.showOptions()
        }
    }
    // MARK: - TopBarDelegate
    internal func pressLeft(sender:UIButton){
        _ = self.navigationController?.popViewController(animated: true)
    }
    internal func pressRight(sender:UIButton){
        //show options
        if isNoDeleteOption == false {
             self.showOptions()
        }
       
    }
    // MARK: - AlertViewController
    func showOptions() {
        let alert = UIAlertController(title: "Caja Album",
                                      message: "Desea eliminar esta foto permanentemente.",
                                      preferredStyle: .actionSheet)
        let defaultButton = UIAlertAction(title: "Eliminar",
                                          style: .destructive) {(_) in
                                            // your defaultButton action goes here
                                            self.deletePhoto(photo: self.currentPhoto)
        }

        let cancelButton = UIAlertAction(title: "Cancelar",
                                          style: .cancel) {(_) in
                                            // your defaultButton action goes here
        }
        
        alert.addAction(defaultButton)
        alert.addAction(cancelButton)
        present(alert, animated: true) {
            // completion goes here
        }
    }
    func deletePhoto(photo:Photos) {
        // followers/uid_user for
        let uid = FIRAuth.auth()!.currentUser!.uid
        let ref = FIRDatabase.database().reference()
        ref.child("followers").child(uid).queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            if (snapshot.value is NSNull) {
                _ = self.navigationController?.popViewController(animated: true)
            } else {
                if let following = snapshot.value as? [String : AnyObject] {
                    for (key , _) in following {
                        self.deleteTimeline(keyUser: key, photo: photo)
//                        if key == user.key {
//                            user.isFollowing = true
//                            let cell:UserTableViewCell = self.discoveryList.tableView.cellForRow(at: indexPath) as! UserTableViewCell
//                            cell.checkFollow(user: user)
//                        }
                    }
                    self.delegate?.completedDeletedPhoto(photo: self.currentPhoto, index: self.currentIndex)
                    _ = self.navigationController?.popViewController(animated: true)
                    ref.child("photos").child(uid).child(photo.key).removeValue()
                    ref.removeAllObservers()
                    
                }
            }
            
        })
        
        

    }
    func deleteTimeline(keyUser:String,photo:Photos){
     //   let keyPhoto = FIRAuth.auth()!.currentUser!.uid
        let ref = FIRDatabase.database().reference()
        ref.child("timeline").child(keyUser).child(photo.key).removeValue()
    }
}
