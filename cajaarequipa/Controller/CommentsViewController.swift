//
//  CommentsViewController.swift
//  cajaarequipa
//
//  Created by Nara on 4/9/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit
import Firebase

class CommentsViewController: BoxViewController ,TopBarDelegate {

    var topBar:TopBar!
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
        topBar.drawBody(leftImage: #imageLiteral(resourceName: "back"), rightImage: #imageLiteral(resourceName: "hide"), title: "Comentarios")
        view.addSubview(topBar)
        
        
    }
    // MARK: - TopBarDelegate
    func pressLeft(sender: UIButton) {
         _ = self.navigationController?.popToRootViewController(animated: true)
      
    }
    
    func pressRight(sender: UIButton) {
        //no actions
    }

}
