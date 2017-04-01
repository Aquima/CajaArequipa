//
//  DiscoveryViewController.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 4/1/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit

class DiscoveryViewController: BoxViewController,TopBarDelegate {

    var topBar:TopBar!
    var discoveryList:DiscoveryList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.createView()
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
        topBar.drawBody(leftImage: #imageLiteral(resourceName: "back"), rightImage: #imageLiteral(resourceName: "hide"), title: "Descubrir Personas")
        view.addSubview(topBar)
        
        discoveryList = DiscoveryList()
        discoveryList.drawBody(barHeight: <#T##CGFloat#>)
        view.addSubview(discoveryList)
        
    }
    // MARK: - TopBarDelegate
    func pressLeft(sender: UIButton) {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    func pressRight(sender: UIButton) {
        
    }
    


}
