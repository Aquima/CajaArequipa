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
    internal func updateFavorited(indexPath: IndexPath, user:TimeLine){
        
    }
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
    
}
