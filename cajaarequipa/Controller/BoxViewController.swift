//
//  BoxViewController.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 3/23/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit

class BoxViewController: UIViewController {
    let screenSize: CGRect = UIScreen.main.bounds
    let valuePro:CGFloat  = CGFloat(NSNumber.getPropotionalValueDevice())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showTopBar()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func showTopBar(){
        let topBar = UIView()
        topBar.backgroundColor = UIColor.init(hexString: GlobalConstants.color.blue)
        topBar.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 18*valuePro)
        view.addSubview(topBar)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
