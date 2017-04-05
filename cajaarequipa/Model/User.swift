//
//  User.swift
//  cajaarequipa
//
//  Created by Raul Quispe on 3/27/17.
//  Copyright © 2017 Next Latinoamérica. All rights reserved.
//

import UIKit

class User: NSObject {
    var key:String!
    var describe:String!
    var name:String!
    var pictureUrl:URL!
    var email:String!
    var document:String!
    var locality:String!
    var website:String!
    var follows:Int!
    var followers:Int!
    var isFollowing:Bool = false
    func translateToModel(data:Dictionary<String, Any>){
        
        describe = data["description"] as! String
        website = data["website"] as! String
        document = data["document"] as! String
        locality = data["locality"] as! String
        email = data["email"] as! String
        //  pictureUrl = data["pictureurl"] as! String
        pictureUrl = URL(string: data["pictureurl"] as! String)
        name = data["name"] as! String
        follows = data["follows"] as! Int
        followers = data["followers"] as! Int

    }
//    func translatefromSanp(snap:FIRDataSnapshot){
//        describe = snap.childSnapshotForPath("description").exists
//        website = data["website"] as! String
//        document = data["document"] as! String
//        locality = data["locality"] as! String
//        email = data["email"] as! String
//        pictureUrl = data["pictureurl"] as! String
//        name = data["name"] as! String
//        follows = data["follows"] as! NSNumber
//        followers = data["followers"] as! NSNumber
//    }
}
