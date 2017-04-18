//
//  Comment.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 4/17/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit
import Firebase

class Comment: NSObject {
    
    var key:String!
    var message:String!
    var timestamp:Date!
    var userPropertier:User!
    func translateToModel(data:Dictionary<String, Any>){

        message = (data["message"] != nil) ? data["message"] as! String : ""
        userPropertier = User()
        userPropertier?.translateToModel(data: data["user"] as! Dictionary<String, Any>)
        let numberSeconds = data["timestamp"] as! NSNumber
        timestamp = Date(timeIntervalSince1970: (numberSeconds.doubleValue / 1000.0))
        updateUser(user: userPropertier)
    }
    func updateUser(user:User){
        let uid:String = user.uid
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
           let value = snapshot.value as? Dictionary<String,Any>
           self.userPropertier.key = user.key
           self.userPropertier.translateToModel(data: value!)

        }) { (error) in
            print(error.localizedDescription)
        }

    }
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
        
        ref.child("comments").child(self.key).childByAutoId().updateChildValues(postComment, withCompletionBlock:  { (error:Error?, ref:FIRDatabaseReference!) in
            // _ = self.navigationController?.popViewController(animated: true)

        })
        
    }
}
