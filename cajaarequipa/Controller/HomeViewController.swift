//
//  HomeViewController.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 3/23/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: BoxViewController,TopBarDelegate,ListTimelineDelegate {

    var topBar:TopBar!
    var listTimeline:ListTimeline!
    var sendData:[TimeLine] = []
    
    var pageNumber = 1
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.createView()
        
        retriveTimeLine()
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
        topBar.drawBody(leftImage: #imageLiteral(resourceName: "hide"), rightImage: #imageLiteral(resourceName: "hide"), title: "Inicio")
        view.addSubview(topBar)
        
        listTimeline = ListTimeline()
        listTimeline.delegate = self
        listTimeline.drawBody(barHeight:(self.tabBarController?.tabBar.frame.size.height)!)
        view.addSubview(listTimeline)
    }
    // MARK: - TopBarDelegate
    func pressLeft(sender: UIButton) {
        //
    }
    
    func pressRight(sender: UIButton) {
        
    }

    // MARK: - Firebase
    func retriveTimeLine(){
        let uid = ApiConsume.sharedInstance.currentUser.key
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        ref.child("timeline").child(uid!).queryOrderedByKey().queryLimited(toFirst:5).observeSingleEvent(of: .value, with:  { (snapshot) -> Void in
            
            
            if (snapshot.value is NSNull) {
                print("retriveTimeLine")
            } else {
                
                for child in snapshot.children {
                    let data:FIRDataSnapshot = child as! FIRDataSnapshot
                     print(data.key)
                    let snapDictionary:Dictionary = data.value! as! Dictionary<String, Any>
                    
                    let timelineItem:TimeLine = TimeLine()
                    timelineItem.key = data.key
                    timelineItem.translateToModel(data: snapDictionary)
                  
                    self.sendData.append(timelineItem)

                }
                self.listTimeline.updateWithData(list: self.sendData)
                ref.removeAllObservers()
            }
            
        })

    }
    // MARK: - ListTimelineDelegate

    internal func loadNewTimeLine(offset : Int,timeline:TimeLine){
        let uid = ApiConsume.sharedInstance.currentUser.key
        self.listTimeline.isLoading = true
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        ref.child("timeline").child(uid!).queryOrderedByKey().queryStarting(atValue: timeline.key).queryLimited(toFirst: UInt(offset)*5).observeSingleEvent(of: .value, with:  { (snapshot) -> Void in
            
            if (snapshot.value is NSNull) {
                print("loadNewTimeLine")
            } else {
                self.sendData.removeLast()
                for child in snapshot.children {
                    let data:FIRDataSnapshot = child as! FIRDataSnapshot
                    print(data.key)
                    let snapDictionary:Dictionary = data.value! as! Dictionary<String, Any>
                    
                    let timelineItem:TimeLine = TimeLine()
                    timelineItem.key = data.key
                    timelineItem.translateToModel(data: snapDictionary)
                    
                    self.sendData.append(timelineItem)

                }
                if snapshot.childrenCount > 1 {
                    self.listTimeline.isLoading = false
                    self.listTimeline.updateWithData(list: self.sendData)
                }else{
                    self.listTimeline.isLoading = true
                }
                
                ref.removeAllObservers()
            }
            
        })

    }
    internal func goProfileViewController(indexPath: IndexPath,timeline:TimeLine){
        
        let publicProfileVC:PublicProfileViewController = PublicProfileViewController()
        publicProfileVC.currentUser = timeline.userPropertier
        timeline.userPropertier?.key = timeline.userPropertier?.uid
        self.navigationController?.pushViewController(publicProfileVC, animated: true)
        
    }
    internal func goCommentsViewController(indexPath: IndexPath,timeline:TimeLine){
        let commentsVC:CommentsViewController = CommentsViewController()
        self.navigationController?.pushViewController(commentsVC, animated: true)
    }
    internal func goShare(indexPath: IndexPath,timeline:TimeLine){
        if let myWebsite = timeline.pictureUrl {
            let objectsToShare = [myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    internal func updateFavorited(indexPath: IndexPath, timeline:TimeLine){
        let uid = ApiConsume.sharedInstance.currentUser.key
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        if timeline.isfavorited == true {
            timeline.isfavorited = false
            if  timeline.likes > 1 {
                timeline.likes  = (timeline.likes  - 1)
            }
            let postTimeline:[String:Any] = ["isfavorited":false,
                                             "likes":timeline.likes]
        
            ref.child("timeline").child(uid!).child(timeline.key).updateChildValues(postTimeline)
            self.listTimeline.tableView.isScrollEnabled = false
            let cell:TimelineTableViewCell = self.listTimeline.tableView.cellForRow(at: indexPath) as! TimelineTableViewCell
            cell.checkFavorited(timeline: timeline)
            self.listTimeline.tableView.isScrollEnabled = true
            
        }else{
            timeline.likes = (timeline.likes + 1)
            timeline.isfavorited = true
            let postTimeline:[String:Any] = ["isfavorited":true,
                                             "likes":timeline.likes]
           
            ref.child("timeline").child(uid!).child(timeline.key).updateChildValues(postTimeline)
            self.listTimeline.tableView.isScrollEnabled = false
            let cell:TimelineTableViewCell = self.listTimeline.tableView.cellForRow(at: indexPath) as! TimelineTableViewCell
            cell.checkFavorited(timeline: timeline)
            self.listTimeline.tableView.isScrollEnabled = true
        }
        self.updateCheckLikes(timeline: timeline)
    }
    func updateCheckLikes(timeline:TimeLine) {
        // timeline es igual a foto por lo tanto tiene el usuario en su nodo
        let uid = timeline.userPropertier?.uid//ApiConsume.sharedInstance.currentUser.key
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        
        if timeline.isfavorited == true {

            ref.child("likes").child(uid!).child(timeline.key).removeValue()
           

        }else{

           
            let post:[String:Any] = [timeline.key:true]
            ref.child("likes").child(uid!).updateChildValues(post)
        }
        let post:[String:Any] = ["likes":7]
        print("photos" + uid! + "/" + timeline.key)
        var refPhotos: FIRDatabaseReference!
        refPhotos = FIRDatabase.database().reference()
        refPhotos.child("photos").child(uid!).child(timeline.key).updateChildValues(post)
        refPhotos.removeAllObservers()
        
    }
}
