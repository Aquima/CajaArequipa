//
//  DetailPhotoViewController.swift
//  cajaarequipa
//
//  Created by Raul on 5/11/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit

class DetailPhotoViewController: BoxViewController,TopBarDelegate {

    var topBar:TopBar!
    var detailPhoto:DetailPhoto!
    var currentPhoto:Photos!
    
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
        topBar.drawBody(leftImage: #imageLiteral(resourceName: "back"), rightImage: #imageLiteral(resourceName: "hide"), title: "Foto")
        view.addSubview(topBar)
        
        detailPhoto = DetailPhoto()
     
        detailPhoto.drawBody(barHeight:(self.tabBarController?.tabBar.frame.size.height)!)
        detailPhoto.loadWithPhoto(photo: currentPhoto)
        view.addSubview(detailPhoto)
    }
    // MARK: - TopBarDelegate
    internal func pressLeft(sender:UIButton){
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    internal func pressRight(sender:UIButton){
        //show options
    }

}
