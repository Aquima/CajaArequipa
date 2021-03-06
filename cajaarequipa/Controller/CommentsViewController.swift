//
//  CommentsViewController.swift
//  cajaarequipa
//
//  Created by Nara on 4/9/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit
import Firebase
protocol CommentsViewControllerDelegate {
    func updateTimelineItem(indexPath:IndexPath,timeline:TimeLine)
}
class CommentsViewController: BoxViewController ,TopBarDelegate, CommentListDelegate {
    var delegate:CommentsViewControllerDelegate?
    var currentUser:User!
    var topBar:TopBar!
    var commentsList:CommentList!
    var currentTimeLine:TimeLine!
    var sendData:[Comment] = []
    var currentIndex:IndexPath!
    var isKeyboardActive:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
        // Do any additional setup after loading the view.
      //  retriveComments()
        listenerCommentsAdded()
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
      
        commentsList = CommentList()
        commentsList.drawBody(barHeight: (self.tabBarController?.tabBar.frame.size.height)!)
        view.addSubview(commentsList)
        commentsList.delegate = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.isKeyboardActive == true {
                self.commentsList.messageTextfield.becomeFirstResponder()
            }
        }
       
        let tapList = UITapGestureRecognizer(target: self, action:#selector(handleTap(sender:)))

        commentsList.addGestureRecognizer(tapList)
        
      //  NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
    }
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            print(keyboardHeight)
        }
    }
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.commentsList.resignFirstResponderList()
    }

    // MARK: - TopBarDelegate
    func pressLeft(sender: UIButton) {
         _ = self.navigationController?.popToRootViewController(animated: true)
      
    }
    
    func pressRight(sender: UIButton) {
        //no actions
    }
    // MARK: - CommentsListDelegate
    internal func postComment(message:String){
        //Comment/uidPhoto/uidComment/
        //comment
        //user: uidUser pictureurl:url name:completename
        let ref = FIRDatabase.database().reference()
        let meUser:User = ApiConsume.sharedInstance.currentUser
        
      //  var postComment: Dictionary<String,Any> = Dictionary()
        let pictureurl:String = (meUser.pictureUrl != nil) ? meUser.pictureUrl.absoluteString : ""
        let userData:Dictionary<String,Any> = ["pictureurl":pictureurl,
                                               "name":meUser.name,
                                               "uid":meUser.key]

        let postComment:[String:Any] = ["message": message,
                                        "user":userData,
                                        "timestamp":FIRServerValue.timestamp()]

        ref.child("comments").child(currentTimeLine.userPropertier.key).child(currentTimeLine.key).child("history").childByAutoId().updateChildValues(postComment, withCompletionBlock:  { (error:Error?, ref:FIRDatabaseReference!) in
           // _ = self.navigationController?.popViewController(animated: true)
            self.commentsList.messageTextfield.resignFirstResponder()
            self.commentsList.messageTextfield.text = ""
            self.commentsList.currentTexfield.text = ""
            self.commentsList.resignFirstResponderList()
         //   self.currentTimeLine.updateTimeline()
            var ref: FIRDatabaseReference!
            ref = FIRDatabase.database().reference()
            ref.child("photos").child(self.currentTimeLine.userPropertier.key).child(self.currentTimeLine.key).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let data:Dictionary = (snapshot.value as? Dictionary<String,Any>)!
                self.currentTimeLine.likes = (data["likes"] != nil) ? data["likes"] as! Int : 0
                self.currentTimeLine.comments = (data["comments"] != nil) ? data["comments"] as! Int : 0
                self.delegate?.updateTimelineItem(indexPath: self.currentIndex, timeline: self.currentTimeLine)
            }) { (error) in
                print(error.localizedDescription)
            }
            
        })
//        let userPropieterData:Dictionary<String,Any> = [currentTimeLine.userPropertier.key:true]
//        ref.child("comments").child(currentTimeLine.key).updateChildValues(userPropieterData)
    }
    // MARK: - Firebase
    func retriveComments(){
  
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        ref.child("comments").child(currentTimeLine.userPropertier.key).child(currentTimeLine.key).child("history").queryOrderedByKey().queryLimited(toFirst:20).observeSingleEvent(of: .value, with:  { (snapshot) -> Void in
            
            
            if (snapshot.value is NSNull) {
                print("retriveTimeLine")
                self.commentsList.updateWithData(list: self.sendData)
                ref.removeAllObservers()
                self.listenerCommentsAdded()
            } else {
                
                for child in snapshot.children {
                    
                    let data:FIRDataSnapshot = child as! FIRDataSnapshot
                    //print(data.key)
                    let snapDictionary:Dictionary = data.value! as! Dictionary<String, Any>
                    
                    let commentItem:Comment = Comment()
                    commentItem.key = data.key
                    commentItem.translateToModel(data: snapDictionary)
                    self.sendData.append(commentItem)
                    
                }
                
                self.commentsList.updateWithData(list: self.sendData)
                ref.removeAllObservers()
            //    self.listenerCommentsAdded()
                
            }
            
        })
        
    }
    func listenerCommentsAdded(){
        var refTimelineAdded: FIRDatabaseReference!
        //escuchar nuestro comments si se agrega un nuevo item en nuestro nodo

        refTimelineAdded = FIRDatabase.database().reference()
        refTimelineAdded.child("comments").child(currentTimeLine.userPropertier.key).child(currentTimeLine.key).child("history").observe(.childAdded, with:  { (snapshot) -> Void in
            // let snap:FIRDataSnapshot
            if (snapshot.value is NSNull) {
                print("loadNewTimeLine")
            } else {

                let snapDictionary = snapshot.value as! Dictionary<String, Any>
  
                let commentItem:Comment = Comment()
                commentItem.key = snapshot.key
                commentItem.translateToModel(data: snapDictionary)
                self.sendData.append(commentItem)
                self.commentsList.updateWithData(list: self.sendData)
                refTimelineAdded.removeAllObservers()
            }
            
        })
    }

}
