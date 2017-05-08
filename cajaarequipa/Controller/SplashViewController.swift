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
//        try! FIRAuth.auth()!.signOut()
//        let notificationName = Notification.Name("goIntro")
//        NotificationCenter.default.post(name: notificationName, object: nil)
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
        
        imageView.frame = CGRect(x: (self.view.frame.size.width-242)/2, y:(self.view.frame.size.height-103)/2, width: 242, height: 103)
        
        let frame =  CGRect(x: (self.view.frame.size.width-25*valuePro)/2, y:100*valuePro + (self.view.frame.size.height)/2, width: 25*valuePro, height: 25*valuePro)
        activityIndicatorView = NVActivityIndicatorView(frame: frame,
                                                        type: NVActivityIndicatorType(rawValue: 1)!)
        activityIndicatorView.color = UIColor.init(hexString: "ffffff")
        activityIndicatorView.startAnimating()
        
        view.addSubview(imageView)
        view.addSubview(activityIndicatorView)
       

           }
    override func viewWillAppear(_ animated: Bool) {
 
        if FIRAuth.auth()?.currentUser != nil {
            // User is signed in.
            var ref: FIRDatabaseReference!
            ref = FIRDatabase.database().reference()
            ref.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                if snapshot.childrenCount == 0 {
                    
                    let logIn = LogInViewController()
                    
                    self.navigationController?.pushViewController(logIn, animated: true)
                }else{
                    let value = snapshot.value as? Dictionary<String,Any>
                    
                    ApiConsume.sharedInstance.currentUser = User()
                    
                    ApiConsume.sharedInstance.currentUser.translateToModel(data: value!)
                    ApiConsume.sharedInstance.currentUser.key = snapshot.key
                    
                    self.timelineFromMe()
                }
                
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
            
        } else {
            // No user is signed in.
            let logIn = LogInViewController()
            
            self.navigationController?.pushViewController(logIn, animated: true)
        }

    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    func loadTabController(){
        let notificationName = Notification.Name("goIntro")
        NotificationCenter.default.addObserver(self, selector: #selector(self.goIntro), name: notificationName, object: nil)
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        if deviceIdiom == .phone {
            self.loadIphoneViewController()
        }else{
            self.loadIpadViewController()
        }
  
    }
    func loadIphoneViewController(){
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
        let valueProTab = tabBarVC.tabBar.frame.size.height*0.8
        imgView.frame = CGRect(x: (screenSize.width-34*valuePro)/2, y: 5, width: valueProTab, height: valueProTab)
        tabBarVC.tabBar.addSubview(imgView)
        self.navigationController?.pushViewController(tabBarVC, animated: true)
    }
    func loadIpadViewController(){
        let homeVC = HomeIPADViewController()
        let iconHome = UITabBarItem(title: "", image: #imageLiteral(resourceName: "homeIcon"), selectedImage: #imageLiteral(resourceName: "homeIconOn"))
        homeVC.tabBarItem = iconHome
        iconHome.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        
        let homeFirstVC = HomeViewController()
      
        
//        let nav1 = NavigationCustomViewController.init(rootViewController: homeFirstVC)
//        nav1.navigationBar.isHidden = true

        let navSplit1 = NavigationCustomViewController.init(rootViewController: homeFirstVC)
        navSplit1.navigationBar.isHidden = true
        
        let searchVCsplit = SearchViewController()
        let navSplit2 = NavigationCustomViewController.init(rootViewController: searchVCsplit)
        navSplit2.navigationBar.isHidden = true
        
        homeVC.viewControllers = [navSplit1,navSplit2]
        
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
        tabBarVC.viewControllers = [homeVC,nav2,nav3,nav4,nav5]
        tabBarVC.tabBar.backgroundColor = UIColor.white
        tabBarVC.tabBar.tintColor = UIColor.init(hexString: "333333")
        let imgView = UIImageView(image: #imageLiteral(resourceName: "cameraIcon"))
        let valueProTab = tabBarVC.tabBar.frame.size.height*0.8
        imgView.frame = CGRect(x: (screenSize.width-34*valuePro)/2, y: 5, width: valueProTab, height: valueProTab)
        tabBarVC.tabBar.addSubview(imgView)
        self.navigationController?.pushViewController(tabBarVC, animated: true)
    }
    func goIntro(notification:Notification){
        NotificationCenter.default.removeObserver(self, name: notification.name, object: nil)
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    func timelineFromMe(){
        let uid = ApiConsume.sharedInstance.currentUser.key
        let ref = FIRDatabase.database().reference()
        //this a reference from get photos
        
        ref.child("photos").child(uid!).queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            if (snapshot.value is NSNull) {
                print("timelineFromUsers")
                self.loadTabController()
            } else {
                if let following = snapshot.value as? [String : AnyObject] {
                    for (keyPhoto , data) in following {
                        var postTimeline:Dictionary<String,Any> = (data as? Dictionary<String,Any>)!
                        let pictureurl:String = (ApiConsume.sharedInstance.currentUser.pictureUrl != nil) ? ApiConsume.sharedInstance.currentUser.pictureUrl.absoluteString : ""
                        let userData:Dictionary<String,Any> = ["pictureurl":pictureurl,
                                                               "name":ApiConsume.sharedInstance.currentUser.name,
                                                               "uid":ApiConsume.sharedInstance.currentUser.key]
                        postTimeline["user"] = userData
                        ref.child("timeline").child(uid!).child(keyPhoto).updateChildValues(postTimeline)
                        
                    }
                    self.loadTabController()
                }
                
            }
            
        })
        
        ref.removeAllObservers()
    }
}
