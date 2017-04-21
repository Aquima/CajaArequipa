//
//  FavoritedViewController.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 3/23/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit

class FavoritedViewController: BoxViewController,TopBarDelegate {

    var topBar:TopBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        createView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func createView(){
        
        view.backgroundColor = UIColor.init(hexString: GlobalConstants.color.white)
        topBar = TopBar()
        topBar.delegate = self
        topBar.drawBody(leftImage: #imageLiteral(resourceName: "back"), rightImage: #imageLiteral(resourceName: "hide"), title: "Favoritos")
        view.addSubview(topBar)
    }


    // MARK: - TopBarDelegate
    internal func pressLeft(sender:UIButton){
        
    }
    internal func pressRight(sender:UIButton){
        
    }
}
