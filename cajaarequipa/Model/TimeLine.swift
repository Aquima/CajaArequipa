//
//  TimeLine.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 4/6/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit
import Firebase

class TimeLine: NSObject {
    
    var key:String!
    var pictureUrl:URL?
    var likes:Int!
    var comments:Int = 0
    var describe:String!
    var userPropertier:User!
    var isfavorited:Bool = false
    var timestamp:Date!
    
    func translateToModel(data:Dictionary<String, Any>){
        let valueFavorited = data["isfavorited"] as! NSNumber
        if valueFavorited == 0 {
            isfavorited = false
        }else{
            isfavorited = true
        }
       // isfavorited = (data["isfavorited"] != nil) ? data["isfavorited"] as! Bool : false
        describe = (data["description"] != nil) ? data["description"] as! String : "Descripción"
        likes = (data["likes"] != nil) ? data["likes"] as! Int : 0
        comments = (data["comments"] != nil) ? data["comments"] as! Int : 0
        pictureUrl = (data["pictureurl"] != nil) ? URL(string: data["pictureurl"] as! String) :  nil
        userPropertier = User()
        userPropertier?.translateToModel(data: data["user"] as! Dictionary<String, Any>)
        let numberSeconds = data["timestamp"] as! NSNumber
        timestamp = Date(timeIntervalSince1970: (numberSeconds.doubleValue / 1000.0))
        updateUser(user: userPropertier)
        updateTimeline()
    }
    func updateUser(user:User){
        self.userPropertier.uid = user.uid
        self.userPropertier.key = user.uid
        let uid:String = user.uid
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? Dictionary<String,Any>
            self.userPropertier.key = user.uid
            self.userPropertier.translateToModel(data: value!)
            self.userPropertier.uid = self.userPropertier.key
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    func updateTimeline(){
        let uid:String = self.userPropertier.uid
       print(uid)
        print(self.key)
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        ref.child("photos").child(uid).child(self.key).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let data:Dictionary = (snapshot.value as? Dictionary<String,Any>)!
            self.likes = (data["likes"] != nil) ? data["likes"] as! Int : 0
            self.comments = (data["comments"] != nil) ? data["comments"] as! Int : 0
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }

}
