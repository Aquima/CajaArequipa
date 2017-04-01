//
//  SplashViewController.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 3/20/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Firebase

class SplashViewController: UIViewController {

    var activityIndicatorView:NVActivityIndicatorView!
    let screenSize: CGRect = UIScreen.main.bounds
    let valuePro:CGFloat  = CGFloat(NSNumber.getPropotionalValueDevice())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FIRApp.configure()
        self.drawBody()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation


    func drawBody(){
        
        view.backgroundColor = UIColor.init(hexString: "002753")
        let valuePro:CGFloat  = CGFloat(NSNumber.getPropotionalValueDevice())
        
        let imageView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        
        imageView.frame = CGRect(x: (self.view.frame.size.width-215*valuePro)/2, y:(self.view.frame.size.height-91*valuePro)/2, width: 215*valuePro, height: 91*valuePro)
        
        let frame =  CGRect(x: (self.view.frame.size.width-25*valuePro)/2, y:100*valuePro + (self.view.frame.size.height)/2, width: 25*valuePro, height: 25*valuePro)
        activityIndicatorView = NVActivityIndicatorView(frame: frame,
                                                        type: NVActivityIndicatorType(rawValue: 1)!)
        activityIndicatorView.color = UIColor.init(hexString: "ffffff")
        activityIndicatorView.startAnimating()
        
        view.addSubview(imageView)
        view.addSubview(activityIndicatorView)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        activityIndicatorView.startAnimating()
        
        let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
           
            if FIRAuth.auth()?.currentUser != nil {
                // User is signed in.
                self.loadTabController()
            } else {
                // No user is signed in.
                let logIn = LogInViewController()
                
                self.navigationController?.pushViewController(logIn, animated: true)
            }
        }
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    func loadTabController(){
        let notificationName = Notification.Name("goIntro")
        NotificationCenter.default.addObserver(self, selector: #selector(self.goIntro), name: notificationName, object: nil)
        
       // let notificationName = Notification.Name("goSplash")
     //   NotificationCenter.default.addObserver(self, selector: #selector(self.goIntro), name: notificationName, object: nil)
        
        let homeVC = HomeViewController()
        let iconHome = UITabBarItem(title: "", image: #imageLiteral(resourceName: "homeIcon"), selectedImage: #imageLiteral(resourceName: "homeIconOn"))
        homeVC.tabBarItem = iconHome
        iconHome.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        let nav1 = NavigationCustomViewController.init(rootViewController: homeVC)
        nav1.navigationBar.isHidden = true
        
        let searchVC = SearchViewController()
        let iconSearch = UITabBarItem(title: "", image: #imageLiteral(resourceName: "searchIcon"), selectedImage: #imageLiteral(resourceName: "searchIconOn"))
        searchVC.tabBarItem = iconSearch
        
       // let tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "more")
        iconSearch.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        let nav2 = NavigationCustomViewController.init(rootViewController: searchVC)
        nav2.navigationBar.isHidden = true
        
        let cameraVC = CameraViewController()
     //   let iconCamera = UITabBarItem(title: "", image: #imageLiteral(resourceName: "cameraIcon"), selectedImage: #imageLiteral(resourceName: "cameraIcon"))
     //   cameraVC.tabBarItem = iconCamera
        
        let nav3 = NavigationCustomViewController.init(rootViewController: cameraVC)
        nav3.navigationBar.isHidden = true
        
        let favoritedVC = FavoritedViewController()
        let iconFavorited = UITabBarItem(title: "", image: #imageLiteral(resourceName: "favoriteIcon"), selectedImage: #imageLiteral(resourceName: "favoriteIconOn"))
        favoritedVC.tabBarItem = iconFavorited
        iconFavorited.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        let nav4 = NavigationCustomViewController.init(rootViewController: favoritedVC)
        nav4.navigationBar.isHidden = true
        
        let profileVC = ProfileViewController()
        let iconProfile = UITabBarItem(title: "", image: #imageLiteral(resourceName: "profileIcon"), selectedImage: #imageLiteral(resourceName: "profileIconOn"))
        profileVC.tabBarItem = iconProfile
        iconProfile.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        let nav5 = NavigationCustomViewController.init(rootViewController: profileVC)
        nav5.navigationBar.isHidden = true
        
        let tabBarVC:UITabBarController = UITabBarController()
        tabBarVC.viewControllers = [nav1,nav2,nav3,nav4,nav5]
        tabBarVC.tabBar.backgroundColor = UIColor.white
        tabBarVC.tabBar.tintColor = UIColor.init(hexString: "333333")
        let imgView = UIImageView(image: #imageLiteral(resourceName: "cameraIcon"))
        imgView.frame = CGRect(x: (screenSize.width-34*valuePro)/2, y: 5, width: 34*valuePro, height: 34*valuePro)
        tabBarVC.tabBar.addSubview(imgView)
        self.navigationController?.pushViewController(tabBarVC, animated: true)
        
    }
    func goIntro(notification:Notification){
        NotificationCenter.default.removeObserver(self, name: notification.name, object: nil)
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
}
